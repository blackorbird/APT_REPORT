""" A plugin for Cutter and Radare2 to deobfuscate APT32 flow graphs
This is a python plugin for Cutter that is compatible as an r2pipe script for
radare2 as well. The plugin will help reverse engineers to deobfuscate and remove
junk blocks from APT32 (Ocean Lotus) samples.
"""
 
__author__  = "Itay Cohen, aka @megabeets_"
__company__ = "Check Point Software Technologies Ltd"
 
# Check if we're running from cutter
try:
    import cutter
    from PySide2.QtWidgets import QAction
    pipe = cutter
    cutter_available = True
# If no, assume running from radare2
except:
    import r2pipe
    pipe = r2pipe.open()
    cutter_available = False
 
 
class GraphDeobfuscator:
    # A list of pairs of opposite conditional jumps
    jmp_pairs = [
        ['jno', 'jo'],
        ['jnp', 'jp'],
        ['jb',	'jnb'],
        ['jl',	'jnl'],
        ['je',	'jne'],
        ['jns', 'js'],
        ['jnz', 'jz'],
        ['jc',	'jnc'],
        ['ja', 'jbe'],
        ['jae', 'jb'],
        ['je',	'jnz'],
        ['jg',  'jle'],
        ['jge', 'jl'],
        ['jpe', 'jpo'],
        ['jne', 'jz']]
 
    def __init__(self, pipe, verbose=False):
        """an initialization function for the class
        
        Arguments:
            pipe {r2pipe} -- an instance of r2pipe or Cutter's wrapper
        
        Keyword Arguments:
            verbose {bool} -- if True will print logs to the screen (default: {False})
        """
 
        self.pipe = pipe
 
        self.verbose = verbose
 
    def is_successive_fail(self, block_A, block_B):
        """Check if the end address of block_A is the start of block_B
 
        Arguments:
            block_A {block_context} -- A JSON object to represent the first block
            block_B {block_context} -- A JSON object to represent the second block
        
        Returns:
            bool -- True if block_B comes immediately after block_A, False otherwise
        """
 
        return ((block_A["addr"] + block_A["size"]) == block_B["addr"])
 
    def is_opposite_conditional(self, cond_A, cond_B):
        """Check if two operands are opposite conditional jump operands
        
        Arguments:
            cond_A {string} -- the conditional jump operand of the first block
            cond_B {string} -- the conditional jump operand of the second block
 
        Returns:
            bool -- True if the operands are opposite, False otherwise
        """
 
        sorted_pair = sorted([cond_A, cond_B])
        for pair in self.jmp_pairs:
            if sorted_pair == pair:
                return True
        return False
 
    def contains_meaningful_instructions (self, block):
        '''Check if a block contains meaningful instructions (references, calls, strings,...)
        
        Arguments:
            block {block_context} -- A JSON object which represents a block
        
        Returns:
            bool -- True if the block contains meaningful instructions, False otherwise
        '''
 
        # Get summary of block - strings, calls, references
        summary = self.pipe.cmd("pdsb @ {addr}".format(addr=block["addr"]))
        return summary != ""
 
    def get_block_end(self, block):
        """Get the address of the last instruction in a given block
        
        Arguments:
            block {block_context} -- A JSON object which represents a block
        
        Returns:
            The address of the last instruction in the block
        """
 
        # save current seek
        self.pipe.cmd("s {addr}".format(addr=block['addr']))
        # This will return the address of a block's last instruction
        block_end = self.pipe.cmd("?v $ @B:-1")
        return block_end
 
    def get_last_mnem_of_block(self, block):
        """Get the mnemonic of the last instruction in a block
        
        Arguments:
            block {block_context} -- A JSON object which represents a block
        
        Returns:
            string -- the mnemonic of the last instruction in the given block
        """
 
        inst_info = self.pipe.cmdj("aoj @ {addr}".format(addr=self.get_block_end(block)))[0]
        return inst_info["mnemonic"]
 
    def get_jump(self, block):
        """Get the address to which a block jumps
        
        Arguments:
            block {block_context} -- A JSON object which represents a block
        
        Returns:
            addr -- the address to which the block jumps to. If such address doesn't exist, returns False 
        """
 
        return block["jump"] if "jump" in block else None
 
    def get_fail_addr(self, block):
        """Get the address to which a block fails
        
        Arguments:
            block {block_context} -- A JSON object which represents a block
        
        Returns:
            addr -- the address to which the block fail-branches to. If such address doesn't exist, returns False 
        """
        return block["fail"] if "fail" in block else None
 
    def get_block(self, addr):
        """Get the block context in a given address
        
        Arguments:
            addr {addr} -- An address in a block
        
        Returns:
            block_context -- the block to which the address belongs
        """
 
        block = self.pipe.cmdj("abj. @ {offset}".format(offset=addr))
        return block[0] if block else None
 
    def get_fail_block(self, block):
        """Return the block to which a block branches if the condition is fails
        
        Arguments:
            block {block_context} -- A JSON representation of a block
        
        Returns:
            block_context -- The block to which the branch fails. If not exists, returns None
        """
        # Get the address of the "fail" branch
        fail_addr = self.get_fail_addr(block)
        if not fail_addr:
            return None
        # Get a block context of the fail address
        fail_block = self.get_block(fail_addr)
        return fail_block if fail_block else None
 
    def reanalize_function(self):
        """Re-Analyze a function at a given address
        
        Arguments:
            addr {addr} -- an address of a function to be re-analyze
        """
        # Seek to the function's start
        self.pipe.cmd("s $F")
        # Undefine the function in this address
        self.pipe.cmd("af- $")
 
        # Define and analyze a function in this address
        self.pipe.cmd("afr @ $")       
 
    def overwrite_instruction(self, addr):
        """Overwrite a conditional jump to an address, with a JMP to it
        
        Arguments:
            addr {addr} -- address of an instruction to be overwritten
        """
 
        jump_destination = self.get_jump(self.pipe.cmdj("aoj @ {addr}".format(addr=addr))[0])
        if (jump_destination):
            self.pipe.cmd("wai jmp 0x{dest:x} @ {addr}".format(dest=jump_destination, addr=addr))
 
    def get_current_function(self):
        """Return the start address of the current function
 
        Return Value:
            The address of the current function. None if no function found.
        """
        function_start = int(self.pipe.cmd("?vi $FB"))
        return function_start if function_start != 0 else None
 
    def clean_junk_blocks(self):
        """Search a given function for junk blocks, remove them and fix the flow.
        """
 
        # Get all the basic blocks of the function
        blocks = self.pipe.cmdj("afbj @ $F")
        if not blocks:
            print("[X] No blocks found. Is it a function?")
            return
        # Have we modified any instruction in the function?
        # If so, a reanalyze of the function is required
        modified = False
 
        # Iterate over all the basic blocks of the function
        for block in blocks:
            fail_block = self.get_fail_block(block)
            # Make validation checks
            if not fail_block or \
            not self.is_successive_fail(block, fail_block) or \
            self.contains_meaningful_instructions(fail_block) or \
            not self.is_opposite_conditional(self.get_last_mnem_of_block(block), self.get_last_mnem_of_block(fail_block)):
                continue
            if self.verbose:
                print ("Potential junk: 0x{junk_block:x} (0x{fix_block:x})".format(junk_block=fail_block["addr"], fix_block=block["addr"]))
            self.overwrite_instruction(self.get_block_end(block))
            modified = True
        if modified:
            self.reanalize_function()
        
    def clean_graph(self):
        """the initial function of the class. Responsible to enable cache and start the cleaning
        """
 
        # Enable cache writing mode. changes will only take place in the session and
        # will not override the binary
        self.pipe.cmd("e io.cache=true")
        self.clean_junk_blocks()
        
 
if cutter_available:
    # This part will be executed only if Cutter is available. This will
    # create the cutter plugin and UI objects for the plugin
    class GraphDeobfuscatorCutter(cutter.CutterPlugin):
        name = "APT32 Graph Deobfuscator"
        description = "Graph Deobfuscator for APT32 Samples"
        version = "1.0"
        author = "Itay Cohen (@Megabeets_)"
 
        def setupPlugin(self):
            pass
 
        def setupInterface(self, main):
            # Create a new action (menu item)
            action = QAction("APT32 Graph Deobfuscator", main)
            action.setCheckable(False)
            # Connect the action to a function - cleaner.
            # A click on this action will trigger the function
            action.triggered.connect(self.cleaner)
 
            # Add the action to the "Windows -> Plugins" menu
            pluginsMenu = main.getMenuByType(main.MenuType.Plugins)
            pluginsMenu.addAction(action)
 
        def cleaner(self):
            graph_deobfuscator = GraphDeobfuscator(pipe)
            graph_deobfuscator.clean_graph()
            cutter.refresh()
 
 
    def create_cutter_plugin():
        return GraphDeobfuscatorCutter()
 
 
if __name__ == "__main__":
    graph_deobfuscator = GraphDeobfuscator(pipe)
    graph_deobfuscator.clean_graph()
 
 
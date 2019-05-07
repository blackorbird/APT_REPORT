import base64

with open(‘cowboy’, ‘r’) as file_in, open(‘cowboy_clear.bin’, ‘wb’) as file_out:

    EncStr = file_in.read()

    BlkSz = 10

    len_EncStr = len(EncStr)

    NonBlk10_ptr = len_EncStr – (BlkSz -1) * (len_EncStr // BlkSz)

    NonBlk10 = EncStr [:NonBlk10_ptr]

    result = ”

    EncStr = EncStr [NonBlk10_ptr::]

    #print EncStr

    x = range (-1,BlkSz-1)

    Blksize1 = len_EncStr // BlkSz

    for n in x:

        loop_buff1_ptr = n * (len_EncStr // BlkSz)

        loop_buff1 = EncStr [loop_buff1_ptr:loop_buff1_ptr+Blksize1]

        #print loop_buff1

        result = loop_buff1 + result

    result = result + NonBlk10

    clear = base64.b64decode(result)[::-1]

    print clear

file_out.write(clear)

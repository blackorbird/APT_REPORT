import socket
import SocketServer
import dnslib
import sys
import json


config_file = sys.argv[1]
redir_server = sys.argv[2]
host = "0.0.0.0"
port = 53

overrides = {}
zones = []
TTL = 60 * 5


def parse_config(config_file):
    f = open(config_file)
    config = json.loads(f.read())
    f.close()
    return config

class MyUDPHandler(SocketServer.BaseRequestHandler):
    def inZone(self, packet):
    try:
        record = dnslib.DNSRecord.parse(packet).q
        f = open('log.txt', 'a')
        f.write(str(record) + '\n')
        f.close()
        print record
    except:
        return False
        for zone in zones:
            if str(record.qname).lower().endswith(zone):
                return True
        return False

    def override(self, packet):
        dns_record = dnslib.DNSRecord.parse(packet)
        if str(dns_record.q.qname).lower() in overrides and dns_record.q.qtype == dnslib.QTYPE.A:
            dns_record.rr = [dnslib.RR(rname=dns_record.q.qname, rtype=dnslib.QTYPE.A, rclass=1, ttl=TTL, rdata=dnslib.A(overrides[str(dns_record.q.qname).lower()]))]
            print 'overrride', dns_record.rr[0]
        '''
        while True:
            change = False
            for i in range(0, len(dns_record.rr)):
                if str(dns_record.rr[i].rname).lower() in overrides:
                    if dns_record.rr[i].rtype == dnslib.QTYPE.A and str(dns_record.rr[i].rdata) != overrides[str(dns_record.rr[i].rname).lower()]:
                        dns_record.rr[i].rdata = dnslib.A(overrides[str(dns_record.rr[i].rname).lower()])
                        change = True
                        print dns_record.rr[i]
                    if dns_record.rr[i].rtype == dnslib.QTYPE.CNAME and str(dns_record.rr[i].rdata).lower() not in overrides:
                        overrides[str(dns_record.rr[i].rdata).lower()] = overrides[str(dns_record.rr[i].rname).lower()]
                        change = True
                        print dns_record.rr[i]
            if not change:
                break
        '''
        return dns_record.pack()

    def handle(self):
        print self.client_address
        data = self.request[0].strip()
        input_socket = self.request[1]
        if self.inZone(data):
            redir_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            redir_socket.sendto(data, (redir_server, 53))
            answer = redir_socket.recv(2048)
            redir_socket.close()
            answer = self.override(answer)
            input_socket.sendto(answer, self.client_address)
        #input_socket.close()

config = parse_config(config_file)
overrides = config['overrides']
zones = config['zones']
server = SocketServer.UDPServer((host, port), MyUDPHandler)
server.serve_forever()


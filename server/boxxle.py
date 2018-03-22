#!/usr/bin/env python

import SimpleHTTPServer
import SocketServer

def main():
    Port = 8000
    httpd = SocketServer.TCPServer(("", Port), SimpleHTTPServer.SimpleHTTPRequestHandler)
    print("Boxxle server. Serving static files from current directory at port {}".format(Port))
    httpd.serve_forever()

if __name__ == "__main__":
    main()

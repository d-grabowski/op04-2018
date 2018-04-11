#!/usr/bin/python

import socket
import threading
import datetime

bindAddress = '0.0.0.0';
bindPort = 9191
receiveData = False

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((bindAddress,bindPort))

server.listen(5)

print ("[*] Listening at %s:%d" % (bindAddress,bindPort))


def handleClient(clientSocket):
	if receiveData:
		request = clientSocket.recv(1024)
		print ("[*] Received data: %s" % request)
	clientSocket.send("Hello world!")
	clientSocket.shutdown(socket.SHUT_RDWR)
	clientSocket.close()

while True:
	client,addr = server.accept()
	print "[*] %s Received connection from: %s:%d" % (datetime.datetime.now(), addr[0],addr[1])
	clientHandler = threading.Thread(target=handleClient,args=(client,))
	clientHandler.start()


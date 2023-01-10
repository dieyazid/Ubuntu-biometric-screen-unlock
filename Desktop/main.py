import socket
import os

IP_ADDRESS = '192.168.1.9'
PORT = 8000

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind the socket to the IP address and port
sock.bind((IP_ADDRESS, PORT))
os.popen('gnome-screensaver-command -l')
while True:
    # Receive message from Flutter app
    data, addr = sock.recvfrom(1024)
    message = data.decode()
    print(f'Received message from Flutter: {message}')
    os.popen('gnome-screensaver-command -d')

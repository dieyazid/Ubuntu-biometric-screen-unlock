import socket
import os
import socket

def get_ipv4():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('10.255.255.255', 1))
        ipv4 = s.getsockname()[0]
    except:
        ipv4 = '127.0.0.1'
    finally:
        s.close()
    return ipv4



IP_ADDRESS = get_ipv4()
PORT = 8000
print(get_ipv4())
# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind the socket to the IP address and port
sock.bind((IP_ADDRESS, PORT))
#os.popen('gnome-screensaver-command -l')
while True:
    # Receive message from Flutter app
    data, addr = sock.recvfrom(1024)
    message = data.decode()
    print(f'Received message from Flutter: {message}')
    os.popen('gnome-screensaver-command -d')
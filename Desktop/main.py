import socket,os,subprocess
IP = "0.0.0.0" 
PORT = 8000

def main():
    # create a socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # bind the socket to the IP and PORT
    sock.bind((IP, PORT))
    # os.popen('gnome-screensaver-command -l')
    while True:
        # receive the message
        data, addr = sock.recvfrom(1024)
        message = data.decode()
        if(message=="unlock"):
            os.popen('gnome-screensaver-command -d')
            print('Unlock')

if __name__ == "__main__":
    main()

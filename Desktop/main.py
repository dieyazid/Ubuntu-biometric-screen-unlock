import os
import time

os.popen('gnome-screensaver-command -l')
while True:
    time.sleep(5)
    os.popen('gnome-screensaver-command -d')
    break

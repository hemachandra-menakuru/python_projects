## The script detect the windows’s inactivity every minute. 
## If the inactivity exceeds 5 minutes, it simply sends an mouse event that move the mouse a little, 
## so the screensaver may think it comes from the user input then reset the timer. 
## Just set the inactivity duration less than the screensaver’s waiting time then run it!


from ctypes import Structure, windll, c_uint, sizeof, byref
import time

class LASTINPUTINFO(Structure):
    _fields_ = [('cbSize', c_uint), ('dwTime', c_uint)]

def get_idle_duration():
    lastInputInfo = LASTINPUTINFO()
    lastInputInfo.cbSize = sizeof(lastInputInfo)
    windll.user32.GetLastInputInfo(byref(lastInputInfo)) 
    millis = windll.kernel32.GetTickCount() - lastInputInfo.dwTime
    return millis / 1000.0

while True:
    d = get_idle_duration()
    #if d > 60 * 5:
    if d > 5:
        windll.user32.mouse_event(1, 1, 1, 0, 0)
    time.sleep(10)

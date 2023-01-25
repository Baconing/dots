from subprocess import Popen, PIPE
import argparse

maxlength = 75

parser = argparse.ArgumentParser("WindowPolybar", "Returns the current window class and name, meant to be ran in polybar.")

parser.add_argument("-l", "--length", help="Max amount of characters before trucated. (Will not truncate the class name.)", type=int, default=75)
args = parser.parse_args()

activeWindowClassP = Popen(["xdotool", "getwindowfocus", "getwindowclassname"], stdout=PIPE)
activeWindowNameP = Popen(["xdotool", "getwindowfocus", "getwindowname"], stdout=PIPE)

activeWindowClass = activeWindowClassP.communicate()
activeWindowName = activeWindowNameP.communicate()

window = activeWindowClass[0].decode('utf-8').split("\n")[0] + " | " + activeWindowName[0].decode('utf-8').split("\n")[0]
final = ""


# failsafe
if len(window.split(" | ")[0]) >= args.length:
    args.length = len(window.split(" | ")[0]) + 4

if len(window) <= args.length:
    print(window)
    exit()

for i in window:
    if len(final) == args.length:
        print(final+"...")
        break
    else:
        final = final + i

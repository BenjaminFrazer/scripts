#!/usr/bin/env sh
nitrogen --restore&
compton&
dwmblocks&
while true; do
    # Log stderror to a file
    autorandr -c&
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
done

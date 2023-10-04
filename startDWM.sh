#!/usr/bin/env sh
compton&
dwmblocks&
while true; do
	setxkbmap -layout gb&
	# Log stderror to a file
	autorandr -c&
	setxkbmap -layout gb&
	nitrogen --restore&
	dwm 2> ~/.dwm.log
	# this means any emojies which may have caused the crash are wiped
	pkill -f dwmblocks
	xsetroot -name ""
	# No error logging
	#dwm >/dev/null 2>&1
done

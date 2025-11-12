#!/bin/sh

SCRIPT_DATE="[2024-10-10]"

# spinner is always the 2nd /bin/sh
spinner_pid=$(pgrep /bin/sh | head -n 2 | tail -n 1)
kill -9 "$spinner_pid"
pkill -9 tail
sleep 0.1

HAS_FRECON=0
if pgrep frecon >/dev/null 2>&1; then
	HAS_FRECON=1
	# restart frecon to make VT1 background black
	exec </dev/null >/dev/null 2>&1
	pkill -9 frecon || :
	rm -rf /run/frecon
	frecon-lite --enable-vt1 --daemon --no-login --enable-vts --pre-create-vts --num-vts=4 --enable-gfx
	until [ -e /run/frecon/vt0 ]; do
		sleep 0.1
	done
	exec </run/frecon/vt0 >/run/frecon/vt0 2>&1
	# note: switchvt OSC code only works on 105+
	printf "\033]switchvt:0\a\033]input:off\a"
	echo "Press CTRL+ALT+F1 if you're seeing this" | tee /run/frecon/vt1 /run/frecon/vt2 >/run/frecon/vt3
else
	exec </dev/tty1 >/dev/tty1 2>&1
	chvt 1
	stty -echo
	echo "Press CTRL+ALT+F1 if you're seeing this" | tee /dev/tty2 /dev/tty3 >/dev/tty4
fi

printf "\033[?25l\033[2J\033[H"

block_char=$(printf "\xe2\x96\x88")
echo "Ck9PT08gICBPT08gIE9PT08gIE9PT08gIE9PT09PICBPT09PICBPT08gIE8gICBPIE9PT09PIE9PT08gIE8gICBPCk8gICBPIE8gICBPIE8gICBPIE8gICBPIE8gICAgIE8gICAgIE8gICBPIE8gICBPIE8gICAgIE8gICBPICBPIE8gCk9PT08gIE9PT09PIE8gICBPIE9PT08gIE9PT08gIE8gICAgIE8gICBPIE8gICBPIE9PT08gIE9PT08gICAgTyAgCk8gICBPIE8gICBPIE8gICBPIE8gICBPIE8gICAgIE8gICAgIE8gICBPICBPIE8gIE8gICAgIE8gICBPICAgTyAgCk9PT08gIE8gICBPIE9PT08gIE8gICBPIE9PT09PICBPT09PICBPT08gICAgTyAgIE9PT09PIE8gICBPICAgTyAgCgo=" | base64 -d | sed "s/O/$block_char/g"

echo "Welcome to BadRecovery (unverified)"
echo "Script date: $SCRIPT_DATE"
echo "https://github.com/BinBashBanana/badrecovery"
echo ""

if [ $HAS_FRECON -eq 1 ]; then
	printf "\033]input:on\a"
else
	stty echo
fi

printf "\033[?25h"
while :; do sh; done

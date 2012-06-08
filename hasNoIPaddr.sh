#!/bin/sh

if [ -z "`ifconfig en1 | fgrep 'inet '`" ]; then
	echo 'Wi-Fi: No IP address'
	exit 0
else
	echo 'Wi-Fi: IP address'
	exit 1
fi

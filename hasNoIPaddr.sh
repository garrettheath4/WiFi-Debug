#!/bin/sh

WIFI='en1'

if [ -z "`ifconfig -l | fgrep en1`" ]; then
	WIFI='en0'
fi

if [ -z "`ifconfig $WIFI | fgrep 'inet '`" ]; then
	echo 'Wi-Fi: No IP address'
	exit 0
else
	echo 'Wi-Fi: IP address'
	exit 1
fi

#!/bin/sh

# Pick network interface for Wi-Fi
WIFI='en1'
if [ -z "`ifconfig -l | fgrep en1`" ]; then
	WIFI='en0'
fi

sudo tcpdump -i "$WIFI" -p -s0 -vv -w ~/Desktop/dhcptrace.pcap "port bootps"

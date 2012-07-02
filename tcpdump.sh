#!/bin/sh

sudo tcpdump -i enX  -p -s0 -vv port bootps -w ~/Desktop/dhcptrace.pcap

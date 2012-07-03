#!/bin/sh

SYSINFO=~/System.spx
SYSLOGDIR=/var/log

# Logs to collect
LOGS="/var/log/kernel.log
/var/log/system.log
/var/log/wifi.log
/var/log/com.apple.IPConfiguration.bootp
/var/log/com.apple.IPConfiguration.DHCPv6"

DATE="`date +%Y.%m.%d-%H.%M.%S`"
REPORTDIR=~/Desktop/"$DATE"

# Pick network interface for Wi-Fi
WIFI='en1'
if [ -z "`ifconfig -l | fgrep en1`" ]; then
	WIFI='en0'
fi

# Create folder to store report data
mkdir "$REPORTDIR"
echo "Saving logs in $REPORTDIR"

# Record date and time
echo "$DATE" > "$REPORTDIR/time.txt"

# System Information Report
if [ -f "$SYSINFO" ]; then
	cp "$SYSINFO" "$REPORTDIR/System.spx"
else
	echo "Please save the system information report as $SYSINFO"
fi

sleep 60

# Collect TCP Dump
sudo killall -SIGTERM tcpdump
touch "$REPORTDIR/dhcptrace.pcap"
sudo -n tcpdump -i "$WIFI" -p -s0 -vv -w "$REPORTDIR/dhcptrace.pcap" "port bootps" &
if [ "$?" -eq 1 ]; then
	echo "Warning: Unable to use sudo to get a tcpdump"
	tcpdump -i "$WIFI" -p -s0 -vv -w "$REPORTDIR/dhcptrace.pcap" "port bootps"
fi

# Gather kernel logs
for log in $LOGS; do
	if [ -f "$log" ]; then
		cp "$log" "$REPORTDIR/"
	else
		echo "Warning: '$log' does not exist"
	fi
done

# Run AirPort scan
/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I -scan > "$REPORTDIR/AirportScan.txt"

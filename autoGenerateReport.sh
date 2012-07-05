#!/bin/sh

SYSINFO=~/System.spx
SYSLOGDIR=/var/log

# Logs to collect
LOGS="/var/log/kernel.log
/var/log/system.log
/var/log/wifi.log
/var/log/com.apple.IPConfiguration.bootp
/var/log/com.apple.IPConfiguration.DHCPv6
/Users/WiFi/Desktop/dhcptrace.pcap"

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

# Make sure tcpdump service is running in the background collecting logs
#  if not, start it in the background and create a pidfile
TCPPIDFILE=~/Desktop/tcpdump.pid
RUNTCPDUMP=1	# NO, don't run tcpdump (default)

if [ -f "$TCPPIDFILE" ]; then
	# Make sure tcpdump is still running for this pid
	TCPPID="`cat $TCPPIDFILE | head -n1`"
	ps -p "$TCPPID"
	if [ "$?" -eq 0 ]; then
		echo "tcpdump is running at the expected pid $TCPPID"
		RUNTCPDUMP=1	# NO, don't run tcpdump
	else
		echo "tcpdump is not running; invalid pidfile: $TCPPID"
		RUNTCPDUMP=0	# YES, run tcpdump
		rm "$TCPPIDFILE"
	fi
else
	echo "No pidfile. Starting tcpdump and creating the pidfile."
	RUNTCPDUMP=0	# YES, run tcpdump
fi

if [ "$RUNTCPDUMP" -eq 0 ]; then	# if YES
	# Can I run passwordless sudo?
	SUDO="`which sudo` -n"
	sudo -n echo hi
	if [ "$?" -eq 1 ]; then
		echo "Warning: Unable to use sudo to get a tcpdump"
		SUDO=""
	fi

	# Start running tcpdump in the background
	$SUDO tcpdump -i "$WIFI" -p -s0 -vv -w ~/Desktop/dhcptrace.pcap "port bootps" &
	SUDOPID="$!"
	sleep 1
	TCPPID=`ps -Af | awk '$3 == '"$SUDOPID"' { print $2 }'`
	echo "tcpdump started with pid $TCPPID"
	echo "$TCPPID" > "$TCPPIDFILE"
fi

sleep 60

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


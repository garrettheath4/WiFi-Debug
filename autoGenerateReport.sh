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

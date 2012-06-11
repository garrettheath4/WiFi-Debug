#!/bin/sh

SYSINFO=~/System.spx

DATE="`date +%Y.%m.%d-%H.%M.%S`"
REPORTDIR=~/Desktop/"$DATE"

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
tar cvzf "$REPORTDIR/kerneltar.tgz" /var/log/kernel.* /var/log/wifi.log

# Run AirPort scan
/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I -scan > "$REPORTDIR/AirportScan.txt"

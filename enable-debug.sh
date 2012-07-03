#!/bin/sh
sudo ipconfig setverbose 1
sudo /usr/libexec/airportd debug +AllUserLand +AllDriver +AllVendor +LogFile

# Enable passwordless sudo for WiFi user
echo "IMPORTANT: Run 'sudo visudo' and add the following line to the end of the file:"
echo "   WiFi	ALL=(ALL) NOPASSWD: ALL"

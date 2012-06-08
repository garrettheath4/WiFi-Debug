#!/bin/sh

DATE="`date +%Y.%m.%d-%H.%M.%S`"
mkdir ~/Desktop/"$DATE"
echo "Saving logs in" ~/Desktop/"$DATE/"
tar cvzf ~/Desktop/"$DATE"/kerneltar.tgz /var/log/kernel.* /var/log/wifi.log

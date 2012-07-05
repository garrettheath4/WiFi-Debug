#!/bin/sh

cd ~/Desktop

for folder in `ls -1d 2012.*`; do
	echo "zip: $folder\t-->\t$folder.zip"
	zip -r "$folder.zip" "$folder"
done

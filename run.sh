#!/usr/bin/env bash
set -e

filename="hass.png"
kindle="192.168.2.2"
image_url="http://geary:5000/2.png"
fbink="/mnt/us/fpink/K3/bin/fbink"


echo "> Downloading"
curl --silent "$image_url" -o "$filename"

#convert image.png -rotate 90
# in place rotation
echo "> Rotationg"
mogrify -rotate -90 "$filename"

echo "> Transfering"
sshpass -p '' scp "$filename" root@$kindle:"/mnt/us/$filename"

echo "> Clearing Screen"
sshpass -p '' ssh -q "root@$kindle" "$fbink" --quiet -c
echo "> Rendering Image"
sshpass -p '' ssh -q "root@$kindle" "$fbink" --quiet -g file="/mnt/us/$filename",w=-1

echo "> Done"

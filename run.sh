#!/usr/bin/env bash
set -e

# deps
# imagemagick sshpass

# ifup enxee4900000000

filename="hass.png"
#kindle="192.168.2.2"
kindle="192.168.250.2"
image_url="http://geary:5000/3.png"
fbink="/mnt/us/fpink/K3/bin/fbink"

ssh_flags="-q -o ConnectTimeout=1 -o ServerAliveInterval=1 -o StrictHostKeyChecking=no"

update_screen() {
    echo "> Downloading"
    curl --silent "$image_url" -o "$filename"

    #convert image.png -rotate 90
    # in place rotation
    #echo "> Rotationg"
    #mogrify -rotate -90 "$filename"

    echo "> Transfering"
    sshpass -p '' scp $ssh_flags "$filename" root@$kindle:"/mnt/us/$filename"

    echo "> Clearing Screen"
    sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet -hk
    #sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet -c #--invert 'a'
    echo "> Rendering Image"
    #sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet --invert -g file="/mnt/us/$filename",w=-1
    sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet -g file="/mnt/us/$filename",w=-1

    echo "> Done"
}


while true
do
    echo "> loop"
    update_screen
    sleep 5m
done


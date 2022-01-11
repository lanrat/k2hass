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
rotate=false

ssh_flags="-q -o ConnectTimeout=1 -o ServerAliveInterval=1 -o StrictHostKeyChecking=no"

refresh_every=10
sleep_duration=5m
count=0

update_screen() {
    echo "> Downloading"
    curl --silent "$image_url" -o "$filename"

    if [ "$rotate" == true ]; then
        #convert image.png -rotate 90
        # in place rotation
        echo "> Rotating"
        mogrify -rotate -90 "$filename"
    fi

    echo "> Transfering"
    sshpass -p '' scp $ssh_flags "$filename" root@$kindle:"/mnt/us/$filename"

    # clear screen every n refreshes
    if ! (($count % $refresh_every)); then
        echo "> Clearing Screen"
        sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet -hk
        #sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet -c #--invert 'a'
    fi

    echo "> Rendering Image"
    #sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet --invert -g file="/mnt/us/$filename",w=-1
    sshpass -p '' ssh $ssh_flags "root@$kindle" "$fbink" --quiet -g file="/mnt/us/$filename",w=-1

    echo "> Done"
}


while true
do
    echo "> loop $count"
    update_screen
    let "count+=1"
    echo ""
    sleep "$sleep_duration"
done


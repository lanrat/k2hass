#!/usr/bin/env bash
#set -e

: "${filename:=hass.png}"
: "${kindle_ip:=192.168.2.2}"
: "${image_url:="https://www.home-assistant.io/images/home-assistant-logo.svg"}"
: "${fbink:=/mnt/us/fpink}"
: "${rotate:=false}"
: "${refresh_every:=4}"
: "${sleep_duration:=5m}"

ssh_flags="-q -o ConnectTimeout=1 -o ServerAliveInterval=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

count=0

update_screen() {
    echo "> Downloading"
    curl  --no-progress-meter  "$image_url" -o "$filename"
    local _ret=$?; if [ $_ret -ne 0 ]; then echo "error: $_ret"; return $_ret; fi

    if [ "$rotate" == true ]; then
        # in place rotation
        echo "> Rotating"
        mogrify -rotate -90 "$filename"
        local _ret=$?; if [ $_ret -ne 0 ]; then echo "error: $_ret"; return $_ret; fi
    fi

    # test brightness hack
    mogrify -brightness-contrast -30x20 "$filename"
    local _ret=$?; if [ $_ret -ne 0 ]; then echo "error: $_ret"; return $_ret; fi

    echo "> Transfering"
    sshpass -p '' scp $ssh_flags "$filename" root@$kindle_ip:"/mnt/us/$filename"
    local _ret=$?; if [ $_ret -ne 0 ]; then echo "error: $_ret"; return $_ret; fi

    # clear screen every n refreshes
    if ! (($count % $refresh_every)); then
        echo "> Clearing Screen"
        sshpass -p '' ssh $ssh_flags "root@$kindle_ip" "$fbink" --quiet -hk
        local _ret=$?; if [ $_ret -ne 0 ]; then echo "error: $_ret"; return $_ret; fi
    fi

    echo "> Rendering Image"
    sshpass -p '' ssh $ssh_flags "root@$kindle_ip" "$fbink" --quiet -g file="/mnt/us/$filename",w=-1
    local _ret=$?; if [ $_ret -ne 0 ]; then echo "error: $_ret"; return $_ret; fi

    echo "> Done"
}

echo "Starting K2HASS"
echo "Kindle IP: $kindle_ip"
echo "ImageURL: $image_url"
echo "RefreshEvery: $refresh_every"
echo "SleepDuration: $sleep_duration"
echo ""

while true
do
    echo "> loop $count"
    echo "> $(date)"
    update_screen
    let "count+=1"
    echo ""
    sleep "$sleep_duration"
done

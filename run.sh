#!/usr/bin/env bash
name="k2hass"

echo "removing old container $name"
docker stop "$name"
docker rm "$name"

echo "starring new $name"
docker run \
    --restart=unless-stopped \
    --name "$name" \
    -d \
    -it \
    -e kindle_ip="192.168.250.2" \
    -e image_url="http://192.168.1.4:5000/3.png" \
    -e fbink="/mnt/us/fpink/K3/bin/fbink" \
    lanrat/k2hass


docker logs --follow "$name"

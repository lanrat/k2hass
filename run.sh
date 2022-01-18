#!/usr/bin/env bash

docker stop k2hass
docker rm k2hass

docker run \
    --restart=unless-stopped \
    --name k2hass \
    -it \
    -e kindle_ip="192.168.250.2" \
    -e image_url="http://192.168.1.4:5000/3.png" \
    -e fbink="/mnt/us/fpink/K3/bin/fbink" \
    lanrat/k2hass


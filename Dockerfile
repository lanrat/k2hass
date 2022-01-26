FROM alpine:latest

RUN apk add --update-cache bash sshpass openssh-client imagemagick curl

USER nobody

COPY k2hass.sh /usr/local/bin/k2hass

WORKDIR /tmp

CMD k2hass

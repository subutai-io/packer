#!/usr/bin/env bash

# default cdn domain
CDN_URL='cdn.subutai.io'

case "$SUBUTAI_ENV" in
  "master")
    CDN_URL='mastercdn.subutai.io'
    ;;
  "dev")
    CDN_URL='devcdn.subutai.io'
    ;;
  "sysnet")
    CDN_URL='sysnetcdn.subutai.io'
    ;;
esac

# get cdn LAN address from resolved domain
CDN_IP=`dig +short $CDN_URL`

# check exist cdn domain
EXIST_CDN_URL=`cat /etc/hosts | grep $CDN_URL`

if [ -z "$EXIST_CDN_URL" ]; then
  echo "$CDN_IP    $CDN_URL" >> /etc/hosts
fi
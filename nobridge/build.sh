#!/bin/bash

# cleanup and set apt proxy port if not configured
rm -rf *.box; rm -rf *.log;
if [ -z "$APT_PROXY_PORT" ]; then
  APT_PROXY_PORT=3142
fi

# echo
# echo "Starting up with values:"
# echo "PROXY_ON        = $PROXY_ON"
# echo "PASSWORD        = $PASSWORD"
# echo "APT_PROXY_PORT  = $APT_PROXY_PORT"
# echo "APT_PROXY_URL   = $APT_PROXY_URL"
# echo "APT_PROXY_HOST  = $APT_PROXY_HOST"
# read

# Checks LAN apt proxies availability
check_proxy() {
  if [ -n "$1" ]; then # if arg provided use it
    echo "Checking proxy URL $1/acng-report.html" >&2
    wget -t 1 --timeout=2 -qO- "$1/acng-report.html" | grep "Transfer statistics"
    return $?
  else # no argument tries env value
    echo "Checking proxy URL $APT_PROXY_URL/acng-report.html" >&2
    wget -t 1 --timeout=2 -qO- "$APT_PROXY_URL/acng-report.html" | grep "Transfer statistics" >&2
    return $?
  fi
}

# Using vbguest to bring down noise - should have this plugin anyways
do_vbguest_plugin() {
  if [ -z "$(vagrant plugin list | grep vagrant-vbguest)" ]; then
    echo "Installing missing vagrant-vbguest plugin" >&2
    vagrant plugin install vagrant-vbguest >&2
  fi
}

do_local_proxy() {
  local local_proxy="http://$(hostname):$APT_PROXY_PORT"
  if [ -n "$(check_proxy $local_proxy)" ]; then
    echo "Local proxy $local_proxy is on! Using it." >&2
    echo $local_proxy
    return 0
  fi

  echo "No local or remote proxy available. Want stand one up? (y/n)" >&2
  read answer

  if [ "$answer" = "y" ]; then
    do_vbguest_plugin >&2
    vagrant up >&2

    while [ -z "$(check_proxy $local_proxy)" ]; do
      echo "Local proxy $local_proxy is not up. Waiting 10s ..." >&2
      sleep 10
    done

    echo "Local proxy $local_proxy is up! Using it." >&2
    echo $local_proxy
    return 0
  else
    echo ""
    return 1
  fi
}

# TODO: extract from variables
PASSWORD="ubuntai"

# check to see if a proxy is configured
if [ -n "$APT_PROXY_URL" ]; then
  echo Proxy configured: APT_PROXY_URL = $APT_PROXY_URL
  if [ -n "$(check_proxy $APT_PROXY_URL)" ]; then
    echo Proxy is on
    PROXY_ON="true"
  else
    echo WARNING: Proxy is off
    APT_PROXY_URL="$(do_local_proxy)"
    if [ -n "$APT_PROXY_URL" ]; then
      APT_PROXY_HOST=$(echo $APT_PROXY_URL|sed -e 's/http:\/\///g')
      PROXY_ON="true"
    else
      APT_PROXY_URL=""
      APT_PROXY_HOST=""
      APT_PROXY_PORT=""
      PROXY_ON="false"
    fi
  fi
else
  APT_PROXY_URL=do_local_proxy
  if [ -n "$APT_PROXY_URL" ]; then
    APT_PROXY_HOST="localhost:$APT_PROXY_PORT"
    APT_PROXY_HOST=$(echo $APT_PROXY_URL|sed -e 's/http:\/\///g')
    PROXY_ON="true"
  else
    APT_PROXY_URL=""
    APT_PROXY_HOST=""
    APT_PROXY_PORT=""
    PROXY_ON="false"
  fi
fi

# echo
# echo "Generating preseed file based on parameters:"
# echo "PROXY_ON        = $PROXY_ON"
# echo "PASSWORD        = $PASSWORD"
# echo "APT_PROXY_PORT  = $APT_PROXY_PORT"
# echo "APT_PROXY_URL   = $APT_PROXY_URL"
# echo "APT_PROXY_HOST  = $APT_PROXY_HOST"
# echo
# read

# TODO: export password from variables in json file
PROXY_ON=$PROXY_ON PASSWORD=$PASSWORD APT_PROXY_PORT=$APT_PROXY_PORT \
   APT_PROXY_URL=$APT_PROXY_URL APT_PROXY_HOST=$APT_PROXY_HOST ./http/xenial.sh

echo "==> Validating template.json ..."
packer validate template.json

if [ "$?" -ne 0 ]; then
  exit 1
fi

echo "==> Running packer build on template.json ..."
date
PROXY_ON=$PROXY_ON PASSWORD=$PASSWORD APT_PROXY_PORT=$APT_PROXY_PORT \
   APT_PROXY_URL=$APT_PROXY_URL APT_PROXY_HOST=$APT_PROXY_HOST       \
   time packer build -on-error=ask -only=virtualbox-iso -except=null template.json
date

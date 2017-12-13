#!/bin/bash

BASE_DIR="`dirname \"$0\"`"
BASE_DIR="`( cd \"$BASE_DIR\" && pwd )`"

# cleanup and set apt proxy port if not configured
rm -rf *.box; rm -rf *.log;
if [ -z "$APT_PROXY_PORT" ]; then
  APT_PROXY_PORT=3142
fi

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

    cd $BASE_DIR/cache
    vagrant up >&2
    cd $BASE_DIR

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


# check for packer
packer=`which packer`
if [ -z "$packer" ]; then 
  echo ' ==> [ERROR] Packer not found'
  exit 1
else 
  echo ' ==> [OK] Packer executable found at '$packer
fi

# check for vagrant
vagrant=`which vagrant`
if [ -z "$vagrant" ]; then 
  echo ' ==> [ERROR] Vagrant not found'
  exit 1
else 
  echo ' ==> [OK] Vagrant executable found at '$vagrant
fi

# check for jsonnet
jsonnet=`which jsonnet`
if [ -z "$jsonnet" ]; then 
  echo ' ==> [ERROR] Jsonnet not found'
  exit 1
else 
  echo ' ==> [OK] Jsonnet executable found at '$jsonnet
fi

# check for vbox
vbox=`which VirtualBox`
if [ -z "$vbox" ]; then 
  echo ' ==> [ERROR] Virtualbox not found'
  exit 1
else 
  echo ' ==> [OK] VirtualBox executable found at '$vbox
fi

echo Clean up output directories and boxes
rm -rf *.box;
rm -rf *.log;
for bt in virtualbox-iso parallels-iso vmware-iso; do
  echo box output directory = "output-$BOXNAME-$bt";
  if [ -d "output-$BOXNAME-$bt" ]; then
    rm -rf "output-$BOXNAME-$bt";
  fi
done

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

# TODO: export password from variables in json file
box=$box BASE_DIR=$BASE_DIR         \
  PROXY_ON=$PROXY_ON                \
  PASSWORD=$PASSWORD                \
  APT_PROXY_PORT=$APT_PROXY_PORT    \
  APT_PROXY_URL=$APT_PROXY_URL      \
  APT_PROXY_HOST=$APT_PROXY_HOST    \
  $BASE_DIR/http/stretch.sh

box=$box BASE_DIR=$BASE_DIR         \
  PROXY_ON=$PROXY_ON                \
  PASSWORD=$PASSWORD                \
  APT_PROXY_PORT=$APT_PROXY_PORT    \
  APT_PROXY_URL=$APT_PROXY_URL      \
  APT_PROXY_HOST=$APT_PROXY_HOST    \
  $BASE_DIR/http/xenial.sh

for box in nat-xenial lan-xenial nat-stretch lan-stretch; do
    echo "==> [$box] Validating $box/template.json ..."
    jsonnet $box/template.jsonnet > $box/template.json

    box=$box BASE_DIR=$BASE_DIR         \
      PROXY_ON=$PROXY_ON                \
      PASSWORD=$PASSWORD                \
      APT_PROXY_PORT=$APT_PROXY_PORT    \
      APT_PROXY_URL=$APT_PROXY_URL      \
      APT_PROXY_HOST=$APT_PROXY_HOST    \
    packer validate $box/template.json

    if [ "$?" -ne 0 ]; then
      echo "[$box][ERROR] Aborting builds due to $box template validation failure."
      exit 1
    fi
done

for box in nat-xenial lan-xenial nat-stretch lan-stretch; do
    echo "==> [$box] Running packer build on $box/template.json ..."

    box=$box BASE_DIR=$BASE_DIR         \
      PROXY_ON=$PROXY_ON                \
      PASSWORD=$PASSWORD                \
      APT_PROXY_PORT=$APT_PROXY_PORT    \
      APT_PROXY_URL=$APT_PROXY_URL      \
      APT_PROXY_HOST=$APT_PROXY_HOST    \
    time packer build -on-error=ask -only=virtualbox-iso -except=null $box/template.json

    if [ "$?" -ne 0 ]; then
      echo "[$box][ERROR] Aborting builds due to $box build failure."
      exit 1
    fi
done

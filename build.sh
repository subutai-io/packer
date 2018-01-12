#!/bin/bash

BASE_DIR="`dirname \"$0\"`"
BASE_DIR="`( cd \"$BASE_DIR\" && pwd )`"

if [ -z "$APT_PROXY_PORT" ]; then
  APT_PROXY_PORT=3142
fi

# TODO: extract from variables
PASSWORD="ubuntai"

if [ -n "$1" ]; then
  VAGRANT_BOXES="$1"
  for box in $VAGRANT_BOXES; do
    case "$box" in
      "xenial")
        break
        ;;
      "stretch")
        break
        ;;
      *) echo "Bad box name in box list: $box"; exit 1
        ;;
    esac
  done
elif [ -z "$VAGRANT_BOXES" ]; then
  VAGRANT_BOXES='xenial stretch'
fi

if [ -n "$2" ]; then
  PACKER_PROVIDERS="$2"
  for provider in $PACKER_PROVIDERS; do
    case "$provider" in
      "virtualbox-iso") echo Enabling virtualbox builder
        break
        ;;
      "qemu") echo Enabling libvirt builder
        break
        ;;
      *) echo "Bad or unsupported provider: $provider"; exit 1
        ;;
    esac
  done
elif [ -z "$PACKER_PROVIDERS" ]; then
  PACKER_PROVIDERS='virtualbox-iso'
fi

# cleanup and set apt proxy port if not configured
rm -rf *.box; rm -rf *.log;
echo Clean up output directories and boxes
for BOXNAME in $VAGRANT_BOXES; do
  for bt in virtualbox-iso parallels-iso vmware-iso; do
    echo box output directory = "output-$BOXNAME-$bt";
    if [ -d "output-$BOXNAME-$bt" ]; then
      rm -rf "output-$BOXNAME-$bt";
    fi
  done
done

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
  echo ' ==> [WARNING] Virtualbox not found'
else 
  echo ' ==> [OK] VirtualBox executable found at '$vbox
fi

# check to see if a proxy is configured
if [ -n "$APT_PROXY_URL" ]; then
  echo 'Proxy configured: APT_PROXY_URL = '$APT_PROXY_URL

  if [ -n "check_proxy $APT_PROXY_URL" ]; then
    echo Proxy is on
    PROXY_ON="true"

    # double check that the APT_PROXY_HOST is also configured with port
    if [ -z "$APT_PROXY_URL" ]; then
      echo " ==> [WARNING] APT_PROXY_URL=$APT_PROXY_URL but APT_PROXY_HOST is undefined"
      echo " ==> [WARNING] Attempting to extract APT_PROXY_HOST from URL"
      APT_PROXY_HOST=$(echo $APT_PROXY_URL|sed -e 's/http:\/\///g')
    fi

    if [ -z "$(echo $APT_PROXY_HOST|awk -F':' '{print $2}')" ]; then
      echo " ==> [ERROR] No port included on APT_PROXY_HOST value of $APT_PROXY_HOST"
      echo " ==> [ERROR] Oddly a port is required in the preseed file. Please add it."
      echo " ==> [ERROR] i.e. $APT_PROXY_HOST:3142 - Terminating ..."
      exit 1
    fi
  else
    echo WARNING: Proxy is off
    APT_PROXY_URL=$(do_local_proxy)
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
  echo 'Proxy NOT configured: APT_PROXY_URL NOT set'
  APT_PROXY_URL=$(do_local_proxy)
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

for box in $VAGRANT_BOXES; do
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

for box in $VAGRANT_BOXES; do
    echo "==> [$box] Running packer build on $box/template.json ..."

    box=$box BASE_DIR=$BASE_DIR         \
      PROXY_ON=$PROXY_ON                \
      PASSWORD=$PASSWORD                \
      APT_PROXY_PORT=$APT_PROXY_PORT    \
      APT_PROXY_URL=$APT_PROXY_URL      \
      APT_PROXY_HOST=$APT_PROXY_HOST    \
    time packer build -on-error=ask -only=$PACKER_PROVIDERS -except=null $box/template.json

    if [ "$?" -ne 0 ]; then
      echo "[$box][ERROR] Aborting builds due to $box build failure."
      echo "build line was:"
      echo "packer build -on-error=ask -only=$PACKER_PROVIDERS -except=null $box/template.json"
      exit 1
    fi

    vagrant box add --force subutai/$box $box*.box
done

#!/bin/bash

# clean up output directories and boxes
rm -rf *.box;
rm -rf *.log;

# Check to see if we have a proxy running
if [ -n "$APT_PROXY_URL" ]; then
  echo Checking defined proxy URL = $APT_PROXY_URL
  PROXY_ON=$(wget -t 1 --timeout=2 -qO- $APT_PROXY_URL/acng-report.html | grep "Transfer statistics");
  if [ -n "$PROXY_ON" ]; then
    echo Proxy is on
    export PROXY_ON="true"
    ## TODO: Extract password from the variables.jsonnet
    PROXY_ON="true" PASSWORD="ubuntai" ./http/xenial.sh
  else
    echo WARNING: Proxy is off
    PASSWORD="ubuntai" ./http/xenial.sh
  fi
fi

echo "==> Validating template.json ..."
packer validate template.json

if [ "$?" -ne 0 ]; then
  exit 1
fi

echo "==> Running packer build on template.json ..."
date
time packer build -on-error=ask -only=virtualbox-iso -except=null template.json
date

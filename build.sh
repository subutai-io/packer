#!/bin/bash

version_now=`grep version variables.jsonnet | \
               awk '{print $2}' | sed -e 's/"//g' -e 's/,//'`
check_version=`aws s3 ls s3://packer-artifacts/boxes/ | \
               sed -e 's/\ *PRE\ *//' -e 's/\///' | grep $version_now`

if [ -n "$check_version" ]; then
  echo Update your version, $version_now boxes have already been uploaded to S3.
  exit 1
fi

if [ ! -f VMwareTools-9.9.2-2496486.tar.gz ]; then
  wget https://s3-eu-west-1.amazonaws.com/packer-artifacts/tools/VMwareTools-9.9.2-2496486.tar.gz
fi

if [ -d subutai-base-virtualbox ]; then
  rm -rf subutai-base-virtualbox;
fi
if [ -d subutai-base-vmware ]; then
  rm -rf subutai-base-vmware;
fi
if [ -d subutai-base-parallels ]; then
  rm -rf subutai-base-parallels;
fi

jsonnet template.jsonnet > template.json
packer validate template.json

if [ "$?" -ne 0 ]; then
  exit 1
fi

time packer build -except=null template.json

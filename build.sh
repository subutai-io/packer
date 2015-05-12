#!/bin/bash

PARENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ -d "$PARENT/../basic" ]; then
  if [ -f "$PARENT/../basic/images.sh" ]; then
    . "$PARENT/../basic/images.sh"
  else
    echo "Cannot find ../basic/images.sh to source"
    exit 1
  fi
else
  echo "You do not have the basic project accessible at ../basic"
  exit 1
fi

version_now="$(grep version variables.jsonnet | \
    awk '{print $2}' | sed -e 's/"//g' -e 's/,//')";
check_version="$(aws s3 ls s3://packer-artifacts/boxes/atlas-dev | \
    sed -e 's/\ *PRE\ *//' -e 's/\///' | grep "$version_now")";

if [ -n "$check_version" ]; then
  echo Update your version, $version_now boxes have already been uploaded to S3.
  exit 1
fi

if [ -d subutai-atlas-dev-virtualbox ]; then
  rm -rf subutai-atlas-dev-virtualbox;
fi
if [ -d subutai-atlas-dev-vmware ]; then
  rm -rf subutai-atlas-dev-vmware;
fi
if [ -d subutai-atlas-dev-parallels ]; then
  rm -rf subutai-atlas-dev-parallels;
fi

jsonnet template.jsonnet > template.json
packer validate template.json

if [ "$?" -ne 0 ]; then
  exit 1
fi

time packer build -except=null,virtualbox-ovf,parallels-pvm template.json
#time packer build -except=null,vmware-vmx,parallels-pvm template.json
#time packer build -except=null,vmware-vmx,virtualbox-ovf template.json
#time packer build -except=null template.json
exit


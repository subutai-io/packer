#!/bin/bash

#
# Downloads resources needed to build the image
#


pushd . > /dev/null
cd `dirname $0` # cd into script directory

BASE_URL=http://nodejs.org/dist/

NODE_VER=`grep node_ver ../variables.jsonnet \
           | awk -F ':' '{print $2}' | sed -e 's/ *"//' -e 's/",*.*//'`
echo NODE_VER = $NODE_VER
NODE_FILE=node-"$NODE_VER"-linux-x86.tar.gz
NODE_URL="$BASE_URL/$NODE_VER/$NODE_FILE"


# Start downloading if they do not already exist
for url in "$NODE_URL"; do
  atfile=`echo $url | awk -F '/' '{print $7}'`
  echo atfile = $atfile

  if [[ -f "$atfile" ]]; then
    echo $atfile exists will NOT download.
  else 
    echo $atfile does NOT EXIST, downloading ...
    wget "$url" >> /dev/null
  fi
done

popd > /dev/null


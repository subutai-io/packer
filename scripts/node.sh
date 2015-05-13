#!/bin/bash

echo Installing NodeJS ...
tar -xvf "node-$NODE_VER-linux-x64.tar.gz" > /dev/null
echo 'export PATH="$HOME"/node-'"$NODE_VER"'-linux-x64/bin:"$PATH"' >> ~/.bashrc


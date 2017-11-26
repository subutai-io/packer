#!/bin/bash

echo Installing NodeJS ...
tar -xvf "node-$NODE_VER-linux-x86.tar.gz" > /dev/null
echo 'export PATH="$HOME"/node-'"$NODE_VER"'-linux-x86/bin:"$PATH"' >> ~/.bashrc


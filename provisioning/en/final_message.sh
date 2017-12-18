#!/bin/bash

/bin/cat <<EOM
Make sure Subutai's E2E Extension/Plugin is installed in your browser
Search for 'Subutai' in your browser's extension/plugin store to find it and install.

EOM

IP=`ip addr show enp0s3 | grep inet | grep -v inet6 | awk '{print $2}' | sed 's/\/.*//'`
if [ "$BRIDGED" == "true" ]; then
    URL='Console URL: https://'$IP':8443'
else
    URL='Console URL: https://localhost:'$_CONSOLE_PORT
fi

/bin/cat <<EOM
    $URL

Default u/p: 'admin' / 'secret'
Vagrant ssh into box and change the 'subutai'/'ubuntai' user password!
If you forget the url above, just take a look in .vagrant/generated.yaml
EOM

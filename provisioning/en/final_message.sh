#!/bin/bash

/bin/cat <<EOM
Make sure Subutai's E2E Extension/Plugin is installed in your browser
Search for 'Subutai' in your browser's extension/plugin store to find it and install.

EOM

echo "SUBUTAI_BRIDGE_IFACE = $SUBUTAI_BRIDGE_IFACE"
get_ip () {
  ip addr show $SUBUTAI_BRIDGE_IFACE | \
    egrep '^[[:space:]]+inet[[:space:]]+' | \
    egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | \
    cut -d$'\n' -f 1
}

if [ "$_BRIDGED" == "true" ]; then
    URL='Console URL: https://'`get_ip`':8443'
else
    URL='Console URL: https://localhost:'$_CONSOLE_PORT
fi

/bin/cat <<EOM
    $URL

Default u/p: 'admin' / 'secret'
Vagrant ssh into box and change the 'subutai'/'ubuntai' user password!
If you forget the url above, just take a look in .vagrant/generated.yml
EOM

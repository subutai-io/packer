#!/bin/bash

/bin/cat <<EOM
Make sure Subutai's E2E Extension/Plugin is installed in your browser
Search for 'Subutai' in your browser's extension/plugin store to find it and install.

Console URL: https://localhost:$CONSOLE_PORT
Default u/p: 'admin' / 'secret'
Vagrant ssh into box and change the 'subutai'/'ubuntai' user password!
If you forget the url above, just take a look in .vagrant/machines/default/virtualbox/console_port
EOM
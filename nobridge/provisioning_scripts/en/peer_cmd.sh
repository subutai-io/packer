#!/bin/bash

/bin/cat <<EOM
Provisioning management capabilities (converting RH into peer)
This might take a little time ...
EOM

/snap/bin/$CMD import management

/bin/cat <<EOM
SUCCESS: Your peer is up. Welcome to the Horde!
-----------------------------------------------

Next steps ...
EOM
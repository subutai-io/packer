#!/bin/bash

set -e

cat <<EOT >> /tmp/sudo.sh
#!/bin/bash
echo subutai ALL=NOPASSWD: ALL >> /etc/sudoers;
EOT
chmod +x /tmp/sudo.sh
echo $SSH_PASSWORD | sudo -S /tmp/sudo.sh

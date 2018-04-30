#!/bin/bash

echo "Allowing for insecure CDN cache node usage."
config="/etc/subutai/agent.conf"
/bin/cat $config \
    | sed -e 's/Allowinsecure.*/Allowinsecure = true/g' \
    > $config.new
mv $config $config.bak
mv $config.new $config
systemctl restart subutai-agent.service
echo "Now you can use a local CDN cache node with a self-signed certificate."

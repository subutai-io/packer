#!/bin/bash

echo "Allowing for insecure CDN cache node usage."
config="/var/snap/$CMD/current/agent.gcfg"
/bin/cat $config \
    | sed -e 's/Allowinsecure.*/Allowinsecure = true/g' \
    > $config.new
mv $config $config.bak
mv $config.new $config
systemctl restart snap.subutai.agent-service.service
echo "Now you can use a local CDN cache node with a self-signed certificate."
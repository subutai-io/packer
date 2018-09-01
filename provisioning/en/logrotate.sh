#!/usr/bin/env bash

if [ "$PROVISION" = "false" ]; then
    exit 0;
fi

# Change LogRotation configuration files

wget --no-cache -O rsyslog https://raw.githubusercontent.com/subutai-io/packer/master/scripts/files/rsyslog >/dev/null 2>&1

cp -f rsyslog /etc/logrotate.d/rsyslog
systemctl restart rsyslog.service
rm rsyslog
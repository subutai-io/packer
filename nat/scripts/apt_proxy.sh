#!/bin/bash


if [ -z "PROXY_ON" ]; then
  exit
fi

cat <<EOT > /tmp/02proxy
Acquire::http::Proxy "$APT_PROXY_URL";
EOT

sudo cp /tmp/02proxy /etc/apt/apt.conf.d/02proxy

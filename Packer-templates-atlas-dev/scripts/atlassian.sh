#!/bin/bash

mkdir -p ~/atlassian/jira
sudo mkdir -p /var/atlassian/jira

mkdir -p ~/atlassian/confluence
sudo mkdir -p /var/atlassian/confluence

mkdir -p ~/atlassian/crowd
sudo mkdir -p /var/atlassian/crowd

mkdir -p ~/atlassian/stash
sudo mkdir -p /var/atlassian/stash

sudo chown -R vagrant:vagrant /var/atlassian

cd atlassian


JAVA_BASE=/usr/lib/jvm
JAVA_VERSION=java-8-oracle

cat >.atlassianrc <<EOL
export JAVA_HOME="$JAVA_BASE/$JAVA_VERSION"
export JRE_HOME="$JAVA_BASE/$JAVA_VERSION/jre"
export PATH="$JAVA_HOME/bin:$PATH"
EOL


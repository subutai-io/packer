#!/bin/bash

mkdir -p ~/atlassian/jira
mkdir -p ~/atlassian/confluence
mkdir -p ~/atlassian/crowd
mkdir -p ~/atlassian/stash

cat >.atlassianrc <<EOL
JAVA_BASE=/usr/lib/jvm
JAVA_VERSION=java-8-oracle
JAVA_HOME=$JAVA_BASE/$JAVA_VERSION
export JAVA_HOME
export PATH=$JAVA_HOME/bin:$PATH
EOL


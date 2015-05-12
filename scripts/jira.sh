#!/bin/bash

cd atlassian/jira
tar -zxf ../atlassian-jira-$JIRA_VER.tar.gz
mv atlassian-jira-$JIRA_VER $JIRA_VER
ln -s $JIRA_VER default

copy ~/jira.init .
sudo ln -s $PWD/jira.init /etc/init.d/jira.init 

cat >.jirarc <<EOL
CATALINA_OPTS="$JVM_OPTS -Xms256m -Xmx256m -XX:MaxPermSize=68m -XX:ReservedCodeCacheSize=28m"
export CATALINA_OPTS
EOL

CATALINA=default/bin/catalina.sh
sed -i '99i' $CATALINA
sed -i '100i. /home/vagrant/atlassian/.atlassianrc' $CATALINA
sed -i '101i. /home/vagrant/atlassian/jira/.jirarc' $CATALINA



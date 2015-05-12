#!/bin/bash

cd atlassian/jira
tar -zxf ~/atlassian-jira-$JIRA_VER.tar.gz
rm -f ~/atlassian-jira-$JIRA_VER.tar.gz
mv atlassian-jira-$JIRA_VER-standalone $JIRA_VER
ln -s $JIRA_VER default

cp ~/jira.init .
sudo ln -s $PWD/jira.init /etc/init.d/jira

cat >.jirarc <<EOL
CATALINA_OPTS="$JVM_OPTS -Xms256m -Xmx512m"
export CATALINA_OPTS
EOL

CATALINA=default/bin/catalina.sh
sed -i '99i\ ' $CATALINA
sed -i '100i. /home/vagrant/atlassian/.atlassianrc' $CATALINA
sed -i '101i. /home/vagrant/atlassian/jira/.jirarc' $CATALINA
sed -i '102i\ ' $CATALINA

echo 'jira.home=/var/atlassian/jira' > \
  default/atlassian-jira/WEB-INF/classes/jira-application.properties



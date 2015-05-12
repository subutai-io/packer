#!/bin/bash

cd atlassian/crowd
tar -zxf ~/atlassian-crowd-$CROWD_VER.tar.gz
rm -f ~/atlassian-crowd-$CROWD_VER.tar.gz
mv atlassian-crowd-$CROWD_VER $CROWD_VER
ln -s $CROWD_VER default

cp ~/crowd.init .
sudo ln -s $PWD/crowd.init /etc/init.d/crowd

cat >.crowdrc <<EOL
CATALINA_OPTS="$JVM_OPTS -Xms128m -Xmx128m -XX:MaxPermSize=28m -XX:ReservedCodeCacheSize=14m"
export CATALINA_OPTS
EOL

CATALINA=default/apache-tomcat/bin/catalina.sh
sed -i '97i\ ' $CATALINA
sed -i '98i. /home/vagrant/atlassian/.atlassianrc' $CATALINA
sed -i '99i. /home/vagrant/atlassian/crowd/.crowdrc' $CATALINA
sed -i '100i\ ' $CATALINA

echo 'crowd.home=/var/atlassian/crowd' >> \
  default/crowd-webapp/WEB-INF/classes/crowd-init.properties



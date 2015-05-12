#!/bin/bash

cd atlassian/confluence
tar -zxf ~/atlassian-confluence-$CONF_VER.tar.gz
rm -f ~/atlassian-confluence-$CONF_VER.tar.gz
mv atlassian-confluence-$CONF_VER $CONF_VER
ln -s $CONF_VER default
cp ~/confluence.init .
sudo ln -s $PWD/confluence.init /etc/init.d/confluence 

cat >.confluencerc <<EOL
CATALINA_OPTS="$JVM_OPTS -Xms256m -Xmx256m -XX:MaxPermSize=68m -XX:ReservedCodeCacheSize=28m"
export CATALINA_OPTS
EOL

CATALINA=default/bin/catalina.sh
sed -i '97i\ ' $CATALINA
sed -i '98i. /home/vagrant/atlassian/.atlassianrc' $CATALINA
sed -i '99i. /home/vagrant/atlassian/confluence/.confluencerc' $CATALINA
sed -i '100i\ ' $CATALINA

echo 'confluence.home=/var/atlassian/confluence' >> \
  default/confluence/WEB-INF/classes/confluence-init.properties



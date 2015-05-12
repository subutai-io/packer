#!/bin/bash

cd atlassian/stash
tar -zxf ../atlassian-stash-$STASH_VER.tar.gz
mv atlassian-stash-$STASH_VER $STASH_VER
ln -s $STASH_VER default

copy ~/stash.init .
sudo ln -s $PWD/stash.init /etc/init.d/stash.init 

cat >.stashrc <<EOL
CATALINA_OPTS="$JVM_OPTS -Xms256m -Xmx256m -XX:MaxPermSize=68m -XX:ReservedCodeCacheSize=28m"
export CATALINA_OPTS
EOL

CATALINA=default/bin/catalina.sh
sed -i '97i' $CATALINA
sed -i '98i. /home/vagrant/atlassian/.atlassianrc' $CATALINA
sed -i '99i. /home/vagrant/atlassian/stash/.stashrc' $CATALINA



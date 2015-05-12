#!/bin/bash

# stash needs git
sudo apt-get -y install git

cd atlassian/stash
tar -zxf ~/atlassian-stash-$STASH_VER.tar.gz
rm -f ~/atlassian-stash-$STASH_VER.tar.gz
mv atlassian-stash-$STASH_VER $STASH_VER
ln -s $STASH_VER default

cp ~/stash.init .
sudo ln -s $PWD/stash.init /etc/init.d/stash

cat >.stashrc <<EOL
CATALINA_OPTS="$JVM_OPTS -Xms256m -Xmx256m -XX:MaxPermSize=68m -XX:ReservedCodeCacheSize=28m"
export CATALINA_OPTS
EOL

CATALINA=default/bin/catalina.sh
sed -i '97i\ ' $CATALINA
sed -i '98i. /home/vagrant/atlassian/.atlassianrc' $CATALINA
sed -i '99i. /home/vagrant/atlassian/stash/.stashrc' $CATALINA
sed -i '100i\ ' $CATALINA

sed -i '3i\ ' default/bin/setenv.sh
sed -i '4iSTASH_HOME=/var/atlassian/stash' default/bin/setenv.sh
sed -i '5iumask 0027' default/bin/setenv.sh
sed -i '6i\ ' default/bin/setenv.sh

# changing the port from 7990 to 7991 to prevent conflict with SDK
cat default/conf/server.xml \
  | sed -e 's/port="7990"/port="7991"/g' \
  > default/conf/server.xml.new
mv default/conf/server.xml default/conf/server.xml.bak
cp default/conf/server.xml.new default/conf/server.xml

 


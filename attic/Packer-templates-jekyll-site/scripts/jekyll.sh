#!/bin/bash

echo Install Jekyll and Setup Start Script
~/.rbenv/versions/2.2.2/bin/gem install jekyll

echo Writing out jekyll start script
cat >/home/vagrant/start_jekyll.sh <<EOL
#!/bin/bash

export PATH=\$HOME/node-$NODE_VER-linux-x86/bin:\$PATH
export PATH=\$HOME/.rbenv/versions\$RUBY_VER/bin:\$PATH
export PATH=\$HOME/.rbenv/libexec:\$PATH
eval "\$(rbenv init -)"
export PATH=\$HOME/.rbenv/plugins/ruby-build/bin:\$PATH

cd $SITE_HOME
jekyll serve --host 0.0.0.0 --detach --watch | tee /home/vagrant/jekyll.out &
exit 0
EOL
chmod +x /home/vagrant/start_jekyll.sh

echo Writing out jekyll stop script
cat >/home/vagrant/stop_jekyll.sh <<EOL
#!/bin/bash

if [ ! -f /home/vagrant/jekyll.out ]; then
  echo Jekyll serve is NOT running ...
  exit 1
fi

JEKYLL_PID="\$(grep 'kill -9' /home/vagrant/jekyll.out | sed -e 's/.*kill -9 //' -e "s/'.*//")"
kill -9 \$JEKYLL_PID

if [ \$? == 0 ]; then
  rm /home/vagrant/jekyll.out
  exit 0
fi
EOL
chmod +x /home/vagrant/stop_jekyll.sh 

echo Installing jekyll init script
sudo cp /home/vagrant/jekyll-serve.init /etc/init.d/jekyll-serve
rm /home/vagrant/jekyll-serve.init



mkdir /home/$SSH_USERNAME/.ssh
chmod 700 /home/$SSH_USERNAME/.ssh
cd /home/$SSH_USERNAME/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/$SSH_USERNAME/.ssh/authorized_keys
chown -R $SSH_USERNAME /home/$SSH_USERNAME/.ssh

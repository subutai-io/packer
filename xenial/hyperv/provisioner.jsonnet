  {
        "type": "shell",
        "execute_command": "export PROXY_ON='{{user `proxy_on`}}';export APT_PROXY_HOST='{{user `apt_proxy_host`}}';export APT_PROXY_URL='{{user `apt_proxy_url`}}';export BRANCHTAG='{{user `branch_or_tag`}}';export DISTRIBUTION='{{user `distribution`}}';export DESKTOP='{{user `desktop`}}';export SSH_USERNAME='{{user `ssh_username`}}';export SSH_PASSWORD='{{user `ssh_password`}}'; echo '{{user `ssh_password`}}' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'",
        "inline": [
          "echo 'subutai ALL=NOPASSWD: ALL' >> /etc/sudoers",
          "date > /home/{{user `ssh_username`}}/vagrant_box_build_time",
          "echo Updating from repositories ...",
          "apt-get -y update",
          "echo Upgrading distribution ...",
          "apt-get -y dist-upgrade",
          "echo Adding needed packages ...",
          "apt-get -y install net-tools snapd inotify-tools",
          "echo Installing btrfs tool",
          "apt-get -y install btrfs-tools",
          "snap install core",
          "echo \"{{user `ssh_username`}}        ALL=(ALL)       NOPASSWD: ALL\" >> /etc/sudoers.d/{{user `ssh_username`}}",
          "chmod 440 /etc/sudoers.d/{{user `ssh_username`}}",
          "mkdir -pm 700 /home/{{user `ssh_username`}}/.ssh",
          "wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/{{user `ssh_username`}}/.ssh/authorized_keys",
          "chmod 0600 /home/{{user `ssh_username`}}/.ssh/authorized_keys",
          "chown -R {{user `ssh_username`}}:{{user `ssh_username`}} /home/{{user `ssh_username`}}/.ssh",
          "cp /tmp/sources.list /etc/apt/sources.list",
          "apt-get update",
          "apt-get install linux-cloud-tools-$(uname -r)",
          "sed -i '1 i\\ulimit -n 65535' /etc/profile"        
        ]
      }
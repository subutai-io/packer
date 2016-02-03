    {
      "type": "virtualbox-iso",
      "boot_command": import "common/bootcommand.jsonnet",
      "boot_wait": "4s",
      "guest_os_type": "Ubuntu_64",
      "http_directory": "preseeds",
      "iso_checksum": "83aabd8dcf1e8f469f3c72fff2375195",
      "iso_checksum_type": "md5",
      "iso_url": "http://releases.ubuntu.com/14.04.2/ubuntu-14.04.2-server-amd64.iso",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso",
      "headless": false,
      "output_directory": "subutai-basic-virtualbox",
      "virtualbox_version_file": ".vbox_version",
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "768"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "2"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--vram",
          "40"
        ]
      ]
    }

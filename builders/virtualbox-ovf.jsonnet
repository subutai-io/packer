    {
      "type": "virtualbox-ovf",
      "source_path": "../base/subutai-base-virtualbox/packer-virtualbox-iso-1430689804.ovf",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "headless": false,
      "output_directory": "subutai-atlas-dev-virtualbox",
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "1536"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "4"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--vram",
          "40"
        ]
      ]
    }

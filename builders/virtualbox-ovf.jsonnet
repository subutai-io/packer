    {
      "type": "virtualbox-ovf",
      "source_path": "{{user `ovf_path`}}",
      "boot_wait": "4s",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "headless": false,
      "output_directory": "subutai-{{user `boxname`}}-virtualbox",
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "512"
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

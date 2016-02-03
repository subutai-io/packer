    {
      "type": "parallels-pvm",
      "source_path": "{{user `pvm_path`}}",
      "boot_wait": "4s",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "ssh_port": 22,
      "parallels_tools_flavor": "lin",
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "output_directory": "subutai-atlas-dev-parallels",
      "prlctl": 
        [
          [ "set", "{{.Name}}", "--memsize", "1536" ],
          [ "set", "{{.Name}}", "--cpus", "4" ],
        ]
    }

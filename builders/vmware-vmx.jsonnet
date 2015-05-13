    {
      "type": "vmware-vmx",
      "source_path": "{{user `vmx_path`}}",
      "boot_wait": "4s",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "ssh_port": 22,
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "output_directory": "subutai-{{user `boxname`}}-vmware",
      "vmx_data": {
        "memsize": "512",
        "numvcpus": "2",
        "cpuid.coresPerSocket": "1"
      }
    }

    {
      "type": "vmware-vmx",
      "source_path": "../base/subutai-base-vmware/packer-vmware-iso.vmx",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "ssh_port": 22,
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "output_directory": "subutai-atlas-dev-vmware",
      "vmx_data": {
        "memsize": "1536",
        "numvcpus": "4",
        "cpuid.coresPerSocket": "1"
      }
    }

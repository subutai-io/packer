    {
      "type": "vmware-iso",
      "boot_command": import "common/bootcommand.jsonnet",
      "boot_wait": "5s",
      "guest_os_type": "linux",
      "http_directory": "preseeds",
      "iso_checksum": "83aabd8dcf1e8f469f3c72fff2375195",
      "iso_checksum_type": "md5",
      "iso_url": "http://releases.ubuntu.com/14.04.2/ubuntu-14.04.2-server-amd64.iso",
      "ssh_username": "{{user `ssh_name`}}",
      "ssh_password": "{{user `ssh_pass`}}",
      "ssh_wait_timeout": "10000s",
      "ssh_port": 22,
      "shutdown_command": "echo 'shutdown -P now' > shutdown.sh; echo {{user `ssh_pass`}} |sudo -S sh 'shutdown.sh'",
      "output_directory": "subutai-basic-vmware",
      "disk_size": 40960,
      "vmx_data": {
        "memsize": "768",
        "numvcpus": "2",
        "cpuid.coresPerSocket": "1"
      }
    }

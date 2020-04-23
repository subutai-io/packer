{
  "type": "virtualbox-iso",
  "vm_name": "{{ user `vm_name` }}",

  "boot_command": import "../../http/ubuntu-boot.jsonnet",
  "boot_wait": "10s",
  "shutdown_command": "echo '{{ user `ssh_password` }}'|sudo -S shutdown -P now",
  "post_shutdown_delay": "1m",

  "disk_size": "{{user `disk_size`}}",
  "hard_drive_interface": "sata",

  "headless": "{{ user `headless` }}",
  "http_directory": "{{user `http`}}",

  "iso_checksum": "{{ user `iso_checksum` }}",
  "iso_checksum_type": "{{ user `iso_checksum_type` }}",
  "iso_urls": [
    "{{ user `iso_path` }}/{{ user `iso_name` }}",
    "{{ user `iso_url` }}"
  ],

  "keep_registered": "{{user `keep_registered`}}",
  "output_directory": "output-{{ user `vm_name` }}",
  "skip_export": "{{user `skip_export`}}",

  "ssh_password": "{{user `ssh_password`}}",
  "ssh_username": "{{user `ssh_username`}}",
  "ssh_wait_timeout": "10000s",

  "guest_os_type": "{{ user `virtualbox_guest_os_type` }}",
  "guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso",
  "virtualbox_version_file": ".vbox_version",
  "vboxmanage": [
    [ "modifyvm", "{{.Name}}", "--nictype0", "virtio" ],
    [ "modifyvm", "{{.Name}}", "--nictype1", "virtio" ],
    [ "modifyvm", "{{.Name}}", "--nictype2", "virtio" ],
    [ "modifyvm", "{{.Name}}", "--memory", "{{ user `memory` }}" ],
    [ "modifyvm", "{{.Name}}", "--cpus", "{{ user `cpus` }}" ]
  ],
}

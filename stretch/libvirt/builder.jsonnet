{
  "type": "qemu",
  "vm_name": "{{ user `vm_name` }}",

  "boot_command": import "../../http/virtio/debian-boot.jsonnet",
  "boot_wait": "10s",
  "shutdown_command": "echo '{{ user `ssh_password` }}'|sudo -S shutdown -P now",

  "disk_size": "{{user `disk_size`}}",
  "disk_interface": "virtio",
  "disk_compression": "false",
  "format": "qcow2",
  // "disk_image": "", TODO[devops] investigate this option for using existing images
  "accelerator": "kvm",
//   "headless": "{{ user `headless` }}",
  "headless": "true",
  "http_directory": "{{user `http`}}",

  "iso_checksum": "{{ user `iso_checksum` }}",
  "iso_checksum_type": "{{ user `iso_checksum_type` }}",
  "iso_urls": [ // TODO check to use correct location for this and other providers
    "{{ user `iso_path` }}/{{ user `iso_name` }}",
    "{{ user `iso_url` }}"
  ],
  // "iso_target_path": "", TODO[devops] investigate for saving to iso images

  "output_directory": "output-qemu-{{ user `vm_name` }}",

  "ssh_password": "{{user `ssh_password`}}",
  "ssh_username": "{{user `ssh_username`}}",
  "ssh_wait_timeout": "10000s",

  "net_device": "virtio-net",
  "qemuargs": [
     [ "-m", "{{user `memory`}}" ],
     [ "-smp", "{{ user `cpus` }},maxcpus=16,cores=4" ],
  ],
}

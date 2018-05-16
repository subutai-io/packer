{
  "type": "vmware-iso",
  "vm_name": "{{ user `vm_name` }}",

  "boot_command": import "../../http/debian-boot.jsonnet",
  "boot_wait": "10s",
  "shutdown_command": "echo '{{ user `ssh_password` }}'|sudo -S shutdown -P now",

  "disk_size": "{{user `disk_size`}}",
  "disk_type_id": "0",

  "headless": "true",

  "http_directory": "{{user `http`}}",

  "iso_checksum": "{{ user `iso_checksum` }}",
  "iso_checksum_type": "{{ user `iso_checksum_type` }}",
  "iso_urls": [ // TODO check to use correct location for this and other providers
    "{{ user `iso_path` }}/{{ user `iso_name` }}",
    "{{ user `iso_url` }}"
   ],

  "output_directory": "output-vmware-{{ user `vm_name` }}",

  "ssh_password": "{{user `ssh_password`}}",
  "ssh_username": "{{user `ssh_username`}}",
  "ssh_wait_timeout": "10000s",
  "vmx_data": {
    "cpuid.coresPerSocket": "1"
  },
  "vmx_remove_ethernet_interfaces": true
}
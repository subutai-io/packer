{
  "type": "parallels-iso",
  "guest_os_type": "debian",
  "vm_name": "{{ user `vm_name` }}",

  "boot_command": import "../../http/ubuntu-boot.jsonnet",
  "boot_wait": "10s",
  "shutdown_command": "echo '{{ user `ssh_password` }}'|sudo -S shutdown -P now",

  "disk_size": "{{user `disk_size`}}",

  "http_directory": "{{user `http`}}",
  "headless": "true",

  "iso_checksum": "{{ user `iso_checksum` }}",
  "iso_checksum_type": "{{ user `iso_checksum_type` }}",
  "iso_urls": [ // TODO check to use correct location for this and other providers
    "{{ user `iso_path` }}/{{ user `iso_name` }}",
    "{{ user `iso_url` }}"
   ],
  "parallels_tools_flavor": "lin",
  "prlctl": [
         [
          "set",
          "{{.Name}}",
          "--memsize",
          "{{ user `memory` }}"
        ],
        [
          "set",
          "{{.Name}}",
          "--cpus",
          "{{ user `cpus` }}"
        ]
      ],
  "prlctl_version_file": ".prlctl_version",
  "parallels_tools_flavor": "lin",
  "output_directory": "output-parallels-{{ user `vm_name` }}",

  "ssh_password": "{{user `ssh_password`}}",
  "ssh_username": "{{user `ssh_username`}}",
  "ssh_wait_timeout": "10000s"
}
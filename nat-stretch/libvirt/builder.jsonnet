{
    "type": "qemu",
    "vm_name": "{{ user `vm_name` }}",

    "accelerator": "kvm",
    "iso_checksum": "{{ user `iso_checksum` }}",
    "iso_checksum_type": "{{ user `iso_checksum_type` }}",
    "iso_urls": [ // TODO check to use correct location for this and other providers
        "{{ user `iso_path` }}/{{ user `iso_name` }}",
        "{{ user `iso_url` }}"
    ],

    "boot_wait": "10s",
    "boot_command": import "../../http/debian-boot.jsonnet",

    "disk_size": "{{user `disk_size`}}",
    "disk_interface": "scsi", // URGENT TODO change this to virtio
    "disk_compression": "false",
    "format": "qcow2",
    // "net_device": "virtio-net",

    "headless": "{{ user `headless` }}",
    "http_directory": "{{user `http`}}",

    "output_directory": "output-{{ user `vm_name` }}-{{user `version`}}-libvirt",

    "shutdown_command": "echo '{{ user `ssh_password` }}'|sudo -S shutdown -P now",
    "ssh_password": "{{user `ssh_password`}}",
    "ssh_username": "{{user `ssh_username`}}",
    "ssh_wait_timeout": "10000s",

    "qemuargs": [
        [ "-m", "{{user `memory`}}" ],
        [ "-smp", "{{ user `cpus` }},maxcpus=16,cores=4" ],
    ],
}

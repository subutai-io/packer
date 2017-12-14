{
    "boot_command": [
        "{{ user `boot_command_prefix` }}",
        "/install/vmlinuz ",
        // "noapic net.ifnames=0 biosdevname=0 ",
        "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/{{ user `preseed` }} ",
        "debian-installer={{ user `locale` }} auto locale={{ user `locale` }} kbd-chooser/method=us ",
        "grub-installer/bootdev=/dev/sda<wait> ",
        "hostname={{ user `hostname` }} ",
        "fb=false debconf/frontend=noninteractive ",
        "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
        "initrd=/install/initrd.gz -- <enter>"
    ],
    "boot_wait": "10s",
    "disk_size": "{{user `disk_size`}}",
    "guest_os_type": "{{ user `virtualbox_guest_os_type` }}",
    "guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso",
    "headless": "{{ user `headless` }}",
    "hard_drive_interface": "sata",
    "http_directory": "{{user `http`}}",
    "iso_checksum": "{{ user `iso_checksum` }}",
    "iso_checksum_type": "{{ user `iso_checksum_type` }}",
    "iso_urls": [
    "{{ user `iso_path` }}/{{ user `iso_name` }}",
    "{{ user `iso_url` }}"
    ],
    "keep_registered": "{{user `keep_registered`}}",
    "output_directory": "output-{{ user `vm_name` }}",
    "post_shutdown_delay": "1m",
    "shutdown_command": "echo '{{ user `ssh_password` }}'|sudo -S shutdown -P now",
    "skip_export": "{{user `skip_export`}}",
    "ssh_password": "{{user `ssh_password`}}",
    "ssh_username": "{{user `ssh_username`}}",
    "ssh_wait_timeout": "10000s",
    "type": "virtualbox-iso",
    "vboxmanage": [
    [ "modifyvm", "{{.Name}}", "--nictype1", "virtio" ],
    [ "modifyvm", "{{.Name}}", "--memory", "{{ user `memory` }}" ],
    [ "modifyvm", "{{.Name}}", "--cpus", "{{ user `cpus` }}" ]
    ],
    "virtualbox_version_file": ".vbox_version",
    "vm_name": "{{ user `vm_name` }}"
}

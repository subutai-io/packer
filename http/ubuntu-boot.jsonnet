[
    "{{ user `boot_command_prefix` }}",
    "/install/vmlinuz noapic ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/{{ user `preseed` }} ",
    "debian-installer={{ user `locale` }} auto locale={{ user `locale` }} kbd-chooser/method=us ",
    "grub-installer/bootdev=/dev/vda<wait> ",
    "hostname={{ user `hostname` }} ",
    "fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
    "initrd=/install/initrd.gz -- <enter>"
]

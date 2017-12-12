{
    "execute_command": "export PROXY_ON='{{user `proxy_on`}}';export APT_PROXY_HOST='{{user `apt_proxy_host`}}';export APT_PROXY_URL='{{user `apt_proxy_url`}}';export BRANCHTAG='{{user `branch_or_tag`}}';export DISTRIBUTION='{{user `distribution`}}';export DESKTOP='{{user `desktop`}}';export SSH_USERNAME='{{user `ssh_username`}}';export SSH_PASSWORD='{{user `ssh_password`}}';echo {{user `ssh_password`}} | sudo -E -S sh '{{ .Path }}'",
    "scripts": [
        "{{user `scripts`}}/sudo.sh",
        "{{user `scripts`}}/build_time.sh",
        "{{user `scripts`}}/authorized_keys.sh",
        "{{user `scripts`}}/apt_proxy.sh",
        "{{user `scripts`}}/apt.sh",
        "{{user `scripts`}}/snap.sh",
        "{{user `scripts`}}/vbox.sh",
        "{{user `scripts`}}/fix_vagrant.sh",
        "{{user `scripts`}}/rc_local.sh",
        "{{user `scripts`}}/grub.sh",
        "{{user `scripts`}}/cleanup.sh"
    ]
}

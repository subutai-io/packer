{
  "output": "vagrant-subutai-{{user `vm_name`}}-hyperv-{{user `version`}}.box",
  local br = if std.extVar('branch') == "prod" then 
    ".\\stretch\\hyperv\\Vagrantfile"
  else
    ".\\stretch\\hyperv\\master\\Vagrantfile",
  "vagrantfile_template": br
}
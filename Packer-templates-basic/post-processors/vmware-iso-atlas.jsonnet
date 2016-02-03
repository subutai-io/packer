{
  "type": "atlas",
  "token": "{{user `atlas_token`}}",
  "only": ["vmware-iso"],
  "artifact": "{{user `atlas_username`}}/{{user `atlas_name`}}",
  "artifact_type": "vagrant.box",
  "metadata": {
    "provider": "vmware",
    "version": "{{user `version`}}",
    "created_at": "{{timestamp}}"
  }
}


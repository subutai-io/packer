{
  "type": "vagrant-s3",
  "only": ["vmware-vmx"],
  "region": "eu-west-1",
  "bucket": "packer-artifacts",
  "box_name": "subutai-atlas-dev-{{user `version`}}-vmware.box",
  "manifest": "subutai-atlas-dev-{{user `version`}}-vmware.json",
  "box_dir": "boxes",
  "access_key": "{{user `aws_key`}}",
  "secret_key": "{{user `aws_secret`}}",
  "version": "{{user `version`}}"
}


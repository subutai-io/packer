{
  "type": "vagrant-s3",
  "only": ["parallels-pvm"],
  "region": "eu-west-1",
  "bucket": "packer-artifacts",
  "box_name": "subutai-atlas-dev-{{user `version`}}-parallels.box",
  "manifest": "subutai-atlas-dev-{{user `version`}}-parallels.json",
  "box_dir": "boxes",
  "access_key": "{{user `aws_key`}}",
  "secret_key": "{{user `aws_secret`}}",
  "version": "{{user `version`}}"
}


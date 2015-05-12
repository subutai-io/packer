{
    "ssh_name": "vagrant",
    "ssh_pass": "vagrant",
    "hostname": "atlas-dev",
    "version": "1.0.0",
    "null_host": "172.16.3.20",
    "aws_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    
    // this is for Atlas Cloud - nothing to do with atlassian
    "atlas_username": "subutai",
    "atlas_name": "base",
    "atlas_token": "{{env `ATLAS_TOKEN`}}",

    // versions of various atlassian products
    "conf_ver": "5.7.4",
    "jira_ver": "6.4.3",
    "crowd_ver": "2.8.2",
    "stash_ver": "3.8.1",

    "ovf_path": "{{env `OVF_PATH`}}",
    "vmx_path": "{{env `VMX_PATH`}}",
    "pvm_path": "{{env `PVM_PATH`}}"
}


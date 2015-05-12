# Atassian Development Image Build

This image is great for building Atlassian plugins and testing them using the
Atlassian Plugin SDK which is installed. In addition to the Atlassian SDK the
standalone versions of each product are available if you want to finally deploy 
and test your plugin on them as well.

## Feature List

* Builds from subutai/basic build
* Uses jsonnet to break up large configuration into peices and enable comments
* Downloads all Atlassian components automatically
* Uses the vagrant user to run Atlassian services
* Maps all the needed atlassian SDK ports as well as the standalone ports

### Standalone and SDK Ports

>  # confluence standalone and plugin sdk ports
>  config.vm.network "forwarded_port", guest: 8090, host: 8090
>  config.vm.network "forwarded_port", guest: 1090, host: 1090
>
>  # jira standalone and plugin sdk ports
>  config.vm.network "forwarded_port", guest: 8080, host: 8080
>  config.vm.network "forwarded_port", guest: 2990, host: 2990
>
>  # crowd standalone and plugin sdk ports
>  config.vm.network "forwarded_port", guest: 8095, host: 8095
>  config.vm.network "forwarded_port", guest: 4990, host: 4990
>
>  # stash standalone and plugin sdk ports
>  config.vm.network "forwarded_port", guest: 7991, host: 7991
>  config.vm.network "forwarded_port", guest: 7990, host: 7990


## Environment Parameters and User Configuration Variables

We have the following user configuration varables of which some depend on 
envionment based settings. For up to date information see the variables.jsonnet
file in the root directory:

* null_host - the IP address of the null builder host for testing
* hostname - the hostname to use for the image
* ssh_name - the name of the ssh user to provision the machine
* ssh_pass - the password of the ssh user ssh_name to provision the machine
* aws_key - the aws access key id for the s3 upload post-processor plugin
* aws_secret - the aws secret for the s3 upload post-processor plugin
* atlas_name - the name of the image for atlas
* atlas_username - the name or org of the image for atlas

### Some Feature Notes

The S3 plugins are disabled since they're problematic. You'll have to build and
deploy straight to S3 by hand unfortunately.


# Notes and Running

# To Do List



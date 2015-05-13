# Jekyll Site Development Box Packer Template

This packer template uses the 'subutai/basic' machine images to build a vagrant
box for use with jekyll based websites. 

## Features

* Uses Jsonnet for modular packer JSON files with comments
* Installs ruby, node, and Jekyll
* Jekyll is setup to run as a service with jekyll serve using node
* Configuration provided in variables.jsonnet to set
** the box name
** the box version
** the ruby version
** the node version
** the site home: set to /vagrant
** can be configured to use other ovf, vmx, and pvm images
* Has ~/start_jekyll.sh and ~/stop_jekyll.sh scripts for quick start and stop

## Usage

You can vagrant up and start up jekyll service as the vagrant user using the
provided start and stop scripts in the vagrant users home directory. You can
also use the service facility like so:

    sudo service jekyll-serve start
    sudo service jekyll-serve stop

If you want the service to start and stop on vagrant up you can setup the 
default run levels like so:

    sudo update-rc.d jekyll-serve defaults

Or instead it might be best to provision the start using the following line 
in your vagrant file:

    config.vm.provision "shell", inline: "sudo service jekyll-serve start"

Note that this box will be installed on the Atlas Cloud using 
'subutai/jekyll-site' as the organization qualified name. 

## To Do List

* Image is large, let's figure out a way to shrink it down:
** Use packer snapshotting feature which should come out soon
** Use some mechanism to remove files from the basic image used
** Do we really need everything on this box?


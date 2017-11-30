Vagrant Techniques
------------------

1. [Awesome Interactive Hack] (https://github.com/hashicorp/vagrant/issues/2662#issuecomment-328838768), might substitute this with local host bash shell execution. Might be good for select menu to configure and drop a subutai.yaml file.
2. [Arguments and Env Vars] (https://goo.gl/VBGfgh), can be used with SUBINT (short for subutai interactive) to trigger local script to ask a few questions.
3. [Automatically Install Gems and Plugins] (https://gist.github.com/sneal/9242343) does not seem to work, can still look for other tactics. Nice [thread] (https://gist.github.com/sneal/9242343) on this.


Useful Code Snippets
--------------------

### Launching a Browser

If we have to install the gem just forget it. Let's look at the code and use.

```ruby
require 'launchy'
Launchy.open("http://localhost:#{consolePort}")
```

### Mac Address for public_lan machines

Going to want to check the uniqueness of Mac addresses
on the LAN via a broadcast ping followed by arp table
lookups:

> ping -c 2 <subnet>.255
> arp -a | grep <macaddr>

Found this [Arp](http://www.rubydoc.info/gems/arp/0.0.1) Ruby Gem that might 
help on macOS and *NIX. I have a feeling it might be best to package a shell
script into the box and run it to figure out if the mac that is generated is
unique. The code below presume the shell script macaddr_uniq.sh is packaged 
into the Vagrant box file.

NOTE: This should only be run once when creating the box on the first 
`vagrant up` so need to check for those conditions with ARGV[0] check 
for up command. Don't know how to check if it is the first up (meaning)
machine creation.

```ruby
# Generate random mac address
# ---------------------------
def gen_mac()
  macaddr_cmd = File.dirname(__FILE__) + "/macaddr_uniq.sh"
  is_mac_uniq = false
  mac = nil

  begin
    # TODO: need to check the arp cache too just in case?
    # starting with 08:00:27 to not freakout vbox
    mac = '080027' + 3.times.map { '%02x' % rand(0..255) }.join()
    system("#{macaddr_cmd} #{mac}")
  end while $?.existstatus > 0
  return mac
end
```

### Might need this

```ruby
# Exit hook to save or restore configurations
at_exit do
  # we save and restore based on the vagrant command
  command = ARGV[0]
  puts "Arguments provided to vagrant"
  ARGV.each { |i| puts i }
  puts "Exit hook on command #{command}"
end
```


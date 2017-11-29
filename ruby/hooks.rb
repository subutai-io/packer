
# Functions dealing with hook scripts

# True if script starts with #!/bin/bash
# --------------------------------------
def shebang?(bash_hook)
    text = File.open(bash_hook).read
    text.gsub!(/\r\n?/, "\n")
    line = text.next
    return line.start_with? "#!/bin/bash"
end
  
# Handle hook scripts or normal files: returns path to file to provision
# ----------------------------------------------------------------------
def hook_handler(hook)
    # hook might be the upload file or an executable to give the path to the 
    # file to be provisioned. Builders can use this to hook into the 
    # provisioning process for new snaps and management templates.
    if hook.nil? then 
        return nil 
    end

    if ! File.executable?(hook) then 
        puts '[WARNING] hook script ' + hook + ' is not executable. Abandoning launch.'
        return nil
    end

    fext = File.extname(hook)
    if fext == '.sh' && shebang?(hook) then
        return `#{hook}`.strip # executes and returns output (should be file)
    elsif fext == '.bat' then
        return `#{hook}`.strip # executes and returns output (should be file)
    else
        puts '[WARNING] hook script not valid bash .sh or .bat. Abandoning launch.'
    end
end
  
  
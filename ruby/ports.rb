require 'socket'
require 'timeout'

# methods dealing with port management


# Finds an available port
# -----------------------
def is_port_open?(host, port)
    Timeout.timeout(1) do
      s = TCPSocket.new(host, port)
      s.close rescue nil
  
      return true
    end
  rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, \
         Errno::ENETUNREACH, Errno::EACCES, Errno::ENOTCONN, \
         Errno::EADDRNOTAVAIL
    return false
end
  
# Finds free port for console and records it in configs
# -----------------------------------------------------
def find_port(port, whatfor, provider)
    if ARGV[0] == "up" then
        while is_port_open?("127.0.0.1", port)
        port += 1
        end
    end

    port_file = ".vagrant/machines/default/#{provider}/#{whatfor}_port"
    file_parent = ".vagrant/machines/default/#{provider}/"
    if File.exists?(file_parent) && File.exists?(port_file) && ARGV[0] != "up"
        portText = IO.read(port_file)
        return portText.to_i
    else
        FileUtils::mkdir_p(file_parent)
        IO.write(port_file, "#{port}")
    end 

    return port
end
  
  
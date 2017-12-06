require 'socket'
require 'timeout'

# methods dealing with port management

# Checks if a port is not available
# ---------------------------------
def port_bound?(host, port)
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

# Finds free port for console and puts in wormstore
# -------------------------------------------------
def find_port(port)
  port += 1 while port_bound?('127.0.0.1', port)
  port
end

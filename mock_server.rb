#!/usr/bin/env ruby 
require 'logger'
require 'eventmachine'


class MockServer < EventMachine::Connection
  LOG = Logger.new('logfile.log', 'daily')
  
  def receive_data(data)
    port, ip = Socket.unpack_sockaddr_in(get_peername)
    LOG.info("#{ip}:#{port}" + " -- " + data)
  end
end

class WebServer < EventMachine::Connection
  def receive_data(data)
    File.open('logfile.log', 'r') do |f|
      data = f.read
      send_data("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{data.bytesize}\r\n#{data}")
      close_connection_after_writing
    end
  end
end

EventMachine.run {
  EventMachine.start_server '0.0.0.0', 10024, MockServer
  puts "Server started"
}

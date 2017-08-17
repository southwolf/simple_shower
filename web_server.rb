#!/usr/bin/env ruby
require 'logger'
require 'eventmachine'

class WebServer < EventMachine::Connection
  def receive_data(data)
    f = File.open('logfile.log')
    lines = f.readlines
    f.close
    out = lines.join("\r\n")
    send_data("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n#{out}")
    close_connection_after_writing
  end
end

EventMachine.run {
  EventMachine.start_server '0.0.0.0', 10025, WebServer
  puts "Web OK"
}

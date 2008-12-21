#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

$running = true

Signal.trap("TERM") do
  puts "[#{Time.now}] sender daemon: ending..."
  $running = false
end

puts "[#{Time.now}] sender daemon: starting..."

while($running) do
   begin
     puts "[#{Time.now}] sender daemon: #{Message.awaiting.count} messages to send"
     Message.awaiting.each { |message| message.deliver! }
   rescue Exception => e
     puts "[#{Time.now}] sender daemon error: #{e.message}"
     puts e.backtrace.join("\n")
   end
  sleep 60
end

require 'socket'

if ARGV.size != 2
  puts "Usage: ruby memdump.rb localhost 11211"
  exit
end

socket = TCPSocket.new(*ARGV)
socket.puts "stats items"

items_h = {}
while s = socket.gets
  break if s =~ /^END/
  if s =~ /^STAT items:(\d+):number (\d+)/
    items_h[$1] = $2;
  end
end

items_h.keys.each do |key|
  socket.puts "stats cachedump #{key} #{items_h[key]}"
end

while s = socket.gets
  break if s =~ /^END/
  puts $1 if s =~ /^ITEM (\w+) .+/
end

socket.close

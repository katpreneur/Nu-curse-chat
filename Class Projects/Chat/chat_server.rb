require 'eventmachine'
require 'obscenity'
require 'yaml'

Obscenity.configure do |config|
  config.replacement = "Nathaniel"
end

class ChatServer < EM::Connection

  @@clients = []

  def post_init
    puts " someone connected"
    @username = nil
    send_data("*** What is your name?\n")
  end

  def receive_data(data)
    if @username
      broadcast(data.strip, @username)
    else
      name = data.gsub(/\s+|[\[\]]/, '').strip[0..20]
      if name.empty?
        send_data("*** What is your name?\n")
      else
        @username = name
        @@clients.push(self)
        broadcast("#{@username} has joined")
        send_data("*** Hi, #{@username}!\n")
      end
    end
  end

  def unbind
    puts "someone disconnected"
    @@clients.delete(self)
    broadcast("#{@username} has left") if @username
  end

  def broadcast(message, author = nil)
    filtered = Obscenity.sanitize message
    prefix = author ? "<#{@username}>" : "***"
    @@clients.each do |client|
      unless client == self
        client.send_data("#{prefix} #{filtered}\n")
      end
    end
  end

end

if __FILE__==$0
  EventMachine.run do
    
    Signal.trap("INT")  { EventMachine.stop }
    Signal.trap("TERM") { EventMachine.stop }

    EventMachine.start_server("0.0.0.0", 9999, ChatServer)
  end
end

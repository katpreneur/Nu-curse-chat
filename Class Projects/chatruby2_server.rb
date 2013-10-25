require 'eventmachine'


module EchoServer
	def post_init
		puts " someone connected to the server."
	end

	def receive_data(data)
		send_data ">>> you sent: #{data}"
		close_connection if data =~ /quit/i 
	end

	def unbind 	
		puts " someone diconnected from the server"
	end
end

EventMachine::run {
	EventMachine::start_server "127.0.0.1", 9999, EchoServer
	puts 'running echo server on 9999'
}

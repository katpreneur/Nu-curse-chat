
require 'eventmachine'

class Client < EM::Connection
 
  def post_init
    send_data('ping')
  end

  def receive_data(data)
    p data
  end
end

class KeyboardHandler < EM::Connection
  include EM::Protocols::LineText2

  attr_reader :queue

  def initialize(q)
    @queue = q
  end

  def receive_line(data)
    @queue.push(data)
  end
end

EM.run {
  q = EM::Queue.new

  EM.connect('127.0.0.1', 9999, Client, q)
  EM.open_keyboard(KeyboardHandler, q)
}
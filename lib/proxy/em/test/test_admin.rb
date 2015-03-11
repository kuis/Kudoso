puts "Load Path: #{File.expand_path('../lib', File.dirname(__FILE__))}"
$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require_relative '../admin_server'

EventMachine.run do
  AdminServer.start
end
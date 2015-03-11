require 'eventmachine'

EM.run do
  EM::DNS::Resolver.nameservers = ['208.67.222.123']
  dns = EM::DNS::Resolver.resolve('www.exampleadultsite.com')

  dns.callback do |*args|
    puts "Success: #{args.inspect}"
  end

  dns.errback do |err|
    puts "Err: #{err.inspect}"
  end
end
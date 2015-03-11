require 'net/ssh'
Net::SSH.start('exceptionhub.com', 'sshback55', :password => "ex9f84mdkc89") do |ssh|
  ssh.forward.remote_to(2222, "exceptionhub.com", 22)
  ssh.loop { true }
end
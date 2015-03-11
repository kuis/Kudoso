require 'rubygems'
require 'daemons'

pwd  = File.dirname(File.expand_path(__FILE__))
puts "PWD: #{pwd}"

Daemons.run('/root/em/proxy.rb', :app_name => 'proxy', :dir =>'/root/em/log', :dir_mode => :normal, :log_output => true)#  do
#   run "proxy.rb"
# end
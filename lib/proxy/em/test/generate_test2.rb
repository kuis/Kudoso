require 'fileutils'
require_relative '../certificate'


Dir[File.dirname(__FILE__) + '/../certs/domains/*'].each do |file|
  puts file
  FileUtils.rm(file)
end

start = Time.now
Certificate.generate('exceptionhub.com')
puts "Total: #{(Time.now - start)}"
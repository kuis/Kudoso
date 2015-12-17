#!/usr/bin/env ruby -w

require 'rubygems'
require 'aws-sdk'

# Tar gzip em
#  --exclude "em/certs/"

# Copy files into em
`cp -r files em/`

# Create tar file
`tar -czvf em.tar.gz --exclude "em/test/" em`

# Remove files
`rm -rf em/files`

puts "Tarred Files"

@s3 = AWS::S3.new(
  :access_key_id     => 'AKIAJTOUXVJOKTWTM2ZQ',
  :secret_access_key => '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'
)

bucket_name = 'dev48701'

@bucket = @s3.buckets[bucket_name]

puts "Writing Files"
# Write tar file
file = @bucket.objects["em.tar.gz"]
file.write(Pathname.new('em.tar.gz'), :content_type => 'binary/octet-stream', :cache_control => "max-age=0")
file.acl = :public_read

# Write version file
version_file = @bucket.objects["version.txt"]
version_file.write(Pathname.new('em/version.txt'), :content_type => 'binary/octet-stream', :cache_control => "max-age=0")
version_file.acl = :public_read

puts "Wrote Files"


puts "Upgrade"
`cd ../../ ; heroku run rails runner "'Router.all.each {|r| r.upgrade }'"`
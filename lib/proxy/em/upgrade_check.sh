#!/bin/sh

web_version=`wget -q -O- http://s3.amazonaws.com/dev48701/version.txt`
local_version=`cat version.txt`

if [ "$web_version" != "" ]
then
  if [ "$web_version" != "$local_version" ]
  then
    echo "Upgrading to $web_version from $local_version..."
    cd /root/
    wget "http://s3.amazonaws.com/dev48701/em.tar.gz"
    tar zxf em.tar.gz
    chown root.root em -R
    rm -rf em.tar.gz

    cp -r /root/em/files/* /

    /etc/init.d/proxy restart

    puts "Upgraded"
  fi
fi
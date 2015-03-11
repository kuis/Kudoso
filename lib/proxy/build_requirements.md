Steps to build image

# Actually, don't do this:
Targeting options -> JFFS

Network -> Firewall -> IP Tables -> (enable) iptables-mod-nat-extra

Disable IPV6

Install ip:
Network -> Routing and Redirection -> ip

needs to use my ruby source

Increase max file descriptors

Add /etc/init.d/proxy
Symlink to /etc/rc.d/S80proxy

Add hardware acceleration: http://wiki.openwrt.org/doc/hardware/cryptographic.hardware.accelerators



- unchecked
Kernel Modules -> Other Modules -> kmod-dialog
Kernel Modules -> USB Support -> kmod-usb-brcm4716
Libraries -> libuci-lua
Kernel Modules -> Proprietary BCM43xx WiFi driver -> kmod-brcm-wl


Maybe:
Network -> PPP
Utilities -> openssl-util


to flash
--------

run ./upload_files.sh to pull out the trx file

Set ethernet to manual:
192.168.1.2
255.255.255.0
192.168.1.1

tftp 192.168.1.1
mode binary
put openwrt-brcm4716-squashfs.trx


after flash
-----------





gem install daemons --no-ri --no-rdoc

chmod +x /etc/init.d/proxy
/etc/init.d/proxy enable





# Fix eventmachine
/usr/lib/ruby/site_ruby/1.9/eventmachine.rb
- change require to:
require '/usr/lib/ruby/site_ruby/1.9/mips-linux/rubyeventmachine.so'

# Remove iconv requirement from json
vi /usr/lib/ruby/1.9/json/common.rb

# configure /etc/config/network - set local lan to 192.168.0.1

opkg update
opkg install luci

/etc/init.d/uhttpd enable
/etc/init.d/uhttpd start


Iconv fix:
/usr/lib/ruby/1.9/json/common.rb


Copy in public keys
/etc/dropbear/authorized_keys



--------- SETUP ROUTER SERVER ----------------
apt-get install ruby-1.9.3 build-essential
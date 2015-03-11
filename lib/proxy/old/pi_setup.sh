# http://freecode.com/articles/configuring-a-transparent-proxywebcache-in-a-bridge-using-squid-and-ebtables
# http://people.apache.org/~amc/tiphares/bridge.html

# TODO: install brctl

brctl addbr br0

brctl addif br0 eth0
brctl addif br0 eth1

ip link set dev eth0 up
ip link set dev eth1 up

# brctl addbr br0 # create bridge device
# brctl stp br0 off # Disable spanning tree protocol
# brctl addif br0 eth0 # Add eth0 to bridge
# brctl addif br0 eth1 # Add eth1 to bridge
# ifconfig eth0 0 0.0.0.0 # Get rid of interface IP addresses
# ifconfig eth1 0 0.0.0.0 # ditto



# Setup the boxes dhcp with dhclient
dhclient eth0



# Setup pip
sudo apt-get install pip python-dev
sudo apt-get install libxml2-dev libxslt1-dev python-lxml ebtables

pip install mitmproxy



ebtables -t broute -A BROUTING -p IPv4 --ip-protocol 6 --ip-destination-port 443 -j redirect --redirect-target ACCEPT


# http://www.dd-wrt.com/wiki/index.php/Squid_Transparent_Proxy
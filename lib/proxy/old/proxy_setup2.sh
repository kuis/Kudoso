#!/bin/sh
CHILLI_IP=192.168.182.1
CHILLI_NET=$CHILLI_IP/24
PROXY_IP=192.168.1.10
PROXY_PORT=3128
LAN_NET=192.168.1.0/24

iptables -t nat -A PREROUTING -i tun0 -s $CHILLI_NET -d $LAN_NET -p tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -i tun0 -s $CHILLI_NET -p tcp --dport 80 -j DNAT --to $PROXY_IP:$PROXY_PORT
iptables -t nat -A POSTROUTING -o br0 -s $PROXY_IP -p tcp -d $CHILLI_NET -j SNAT --to $CHILLI_IP
iptables -I FORWARD -i tun0 -o br0 -s $CHILLI_NET -d $PROXY_IP -p tcp --dport $PROXY_PORT -j ACCEPT
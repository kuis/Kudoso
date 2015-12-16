scp -r em root@192.168.98.1:/root/

ssh root@192.168.98.1 -C "rm -rf /tmp/certs ; rm /root/em/certs/domains/* ; /etc/init.d/proxy restart"

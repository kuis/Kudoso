Set the computers static IP to 192.168.11.2, netmask 255.255.255.0, gateway/DNS 192.168.11.1

sudo arp -s 192.168.11.1 00:1D:12:34:56:78 ifscope en0

curl -T openwrt-ar71xx-generic-whr-hp-g300n-squashfs-tftp.bin tftp://192.168.11.1

curl -T openwrt-ar71xx-generic-wzr-hp-g300nh-squashfs-tftp.bin tftp://192.168.11.1

curl -T buffalo-to-dd-wrt_webflash-MULTI.bin tftp://192.168.1.1


tftp 192.168.1.1
mode binary
put path
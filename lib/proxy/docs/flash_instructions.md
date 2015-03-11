Disable wireless

Connect ethernet cable to lan1

Set USB ethernet to:
ip: 192.168.1.2
netmask: 255.255.255.0
gateway: 192.168.1.1

cd into folder with image file

run:

tftp 192.168.1.1
mode binary

[ then plug in router holding red button for 5 seconds ]

put openwrt-brcm4716-squashfs.trx

[ it should fail once with something like:
Error code 768: transfer cancelled
Sent 3866624 bytes in 8.3 seconds
]

[ press the up arrow, unplug and plug it in again holding the red button for 5 seconds, then run the put again ]

[ If that works, leave it plugged in for 4 minutes, then unplug and restart ]


CTRL+D to exit
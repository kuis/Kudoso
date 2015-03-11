# gem install vagrant-sync

# Boot up vagrant
cd /Users/ryanstout/Sites/datingapp/vagrant
# vagrant up


echo "Upload files"
vagrant sync --from /Users/ryanstout/Sites/kudosa/Kudosa/lib/proxy/files --to /home/vagrant/openwrt/asus6/openwrt-r32096/
echo "Upload em"
vagrant sync --from /Users/ryanstout/Sites/kudosa/Kudosa/lib/proxy/em --to /home/vagrant/openwrt/asus6/openwrt-r32096/files/root/

vagrant ssh -c "cd /home/vagrant/openwrt/asus6/openwrt-r32096 ; make -j 8"

image_file=/Users/ryanstout/Sites/kudosa/firmware/finals/kudoso-image-`cat /Users/ryanstout/Sites/kudosa/Kudosa/lib/proxy/em/version.txt`.trx
image_file_name=kudoso-image-`cat /Users/ryanstout/Sites/kudosa/Kudosa/lib/proxy/em/version.txt`.trx

echo "Download Image"
rsync -az vagrant@127.0.0.1:/home/vagrant/openwrt/asus6/openwrt-r32096/bin/brcm4716/openwrt-brcm4716-squashfs.trx -e "ssh -p2222 -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oPasswordAuthentication=no -oIdentitiesOnly=yes -i/Users/ryanstout/.vagrant.d/insecure_private_key" $image_file

# Email file to Rob
if [ -n "$ROB" ]
then
  uuencode  $image_file $image_file_name | mail -s "Version $image_file of Kudoso Firmware" robzarry@gmail.com
fi

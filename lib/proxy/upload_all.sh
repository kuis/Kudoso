# echo "Upload pem file"
# rsync -avz -e ssh em/certs/ca.pem root@exceptionhub.com:/var/www/app/exceptionhub/current/public/
# rsync -avz -e ssh em/certs/root.pem root@exceptionhub.com:/var/www/app/exceptionhub/current/public/
# rsync -avz -e ssh em/certs/root2.pem root@exceptionhub.com:/var/www/app/exceptionhub/current/public/
cp em/certs/root.pem ../../public/



# generate the key
# cd em/test/ ; ruby generate_ca.rb
# cd ../..

./upload_eh.sh
#
echo "Restart bluepill"
ssh root@router.kudoso.com -C "rm -rf /root/em/em/certs/domains/* ; bluepill restart"

echo "Restart proxy"
# ssh root@192.168.0.1 -C "rm -rf /tmp/certs ; rm /root/em/certs/domains/* ; /etc/init.d/proxy restart"


# echo "The Cert" | sendmail ryanstout@gmail.com /A


# Uploads the code to router.kudoso.com
rsync -avz -e ssh em root@router.kudoso.com:/root/em


ssh root@router.kudoso.com -C "bluepill load /root/em/em/servers/server.pill ; bluepill restart"
#!/bin/bash
#tar czvf /deploy/Prod-mwf-current.tgz /deploy/mwf
tar czvf /deploy/Prod-mwf-current.tgz /var/www/mwf_dedicated/default/root
cp /deploy/Prod-mwf-current.tgz /var/www/html/

for i in `/usr/local/bin/instance-info2.sh -t Production -s mwf`;do
#rsync -e "ssh -i /root/cenic-mwf.pem" --del -r /deploy/mwf/* root@$i:/var/www/html/
rsync -e "ssh -i /root/cenic-mwf.pem" --del -r /var/www/mwf_dedicated/default/root/* root@$i:/var/www/html/
done

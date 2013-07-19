#!/bin/bash
#MWF_BASE=/var/www/mwf_dedicated
#MWF_APACHE_CONFIGS1=/etc/httpd/sites-enabled/
#MWF_APACHE_CONFIGS2=/etc/httpd/sites-available/

MWF_BASE=/var/www/mwf/ucla.stage
MWF_APACHE_CONFIGS1=/etc/httpd/sites-enabled/
MWF_APACHE_CONFIGS2=/etc/httpd/sites-available/
tar czvf /deploy/Staging-mwf-current.tgz $MWF_BASE
cp /deploy/Staging-mwf-current.tgz /var/www/html/

for i in `/usr/local/bin/instance-info2.sh -t Staging -s mwf`;do
rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_BASE/* root@$i:$MWF_BASE/
rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_APACHE_CONFIGS1 root@$i:$MWF_APACHE_CONFIGS1
rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_APACHE_CONFIGS2 root@$i:$MWF_APACHE_CONFIGS2
ssh -i /root/cenic-mwf.pem root@$i "service httpd reload"
done

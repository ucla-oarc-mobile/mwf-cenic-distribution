#!/bin/bash
MWF_BASE=/var/www/mwf_dedicated
MWF_APACHE_CONFIGS=/etc/httpd/sites-enabled/

for i in `/usr/local/bin/instance-info2.sh -t Production -s mwf`;do
rsync -e "ssh -i /root/cenic-mwf.pem" --del -r /etc/httpd/conf.d/alias.mwf.default.conf root@$i:/etc/httpd/conf.d/
ssh -i /root/cenic-mwf.pem root@$i "service httpd reload"
done

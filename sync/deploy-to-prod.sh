#!/bin/bash
#MWF_BASE=/var/www/mwf_dedicated
#MWF_APACHE_CONFIGS1=/etc/httpd/sites-enabled/
#MWF_APACHE_CONFIGS2=/etc/httpd/sites-available/

MWF_APACHE_CONFIGS="/etc/httpd/sites-enabled/ /etc/httpd/sites-available/ /etc/httpd/conf.d/"
MWF_BASE_hosts="/var/www/mwf/ucla.production /var/www/mwf/ucla_12.production /var/www/mwf/berkeley.production"


for MWF_BASE in $MWF_BASE_hosts 
do
#  tar czvf /deploy/Production-mwf-current.tgz $MWF_BASE
#  cp /deploy/Production-mwf-current.tgz /var/www/html/

  for i in `/usr/local/bin/instance-info2.sh -t Production -s mwf`
  do
    echo doing a -- rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_BASE/* root@$i:$MWF_BASE/
    rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_BASE/* root@$i:$MWF_BASE/
  done
done

for i in `/usr/local/bin/instance-info2.sh -t Production -s mwf`
do
  for MWF_http_config in $MWF_APACHE_CONFIGS
    echo doing a -- rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_http_config root@$i:$MWF_http_config
    rsync -e "ssh -i /root/cenic-mwf.pem" --del -a -r $MWF_http_config root@$i:$MWF_http_config
  done
  ssh -i /root/cenic-mwf.pem root@$i "service httpd reload"
done

currdate=`date +"%s"`
current="Production-mwf-$currdate.tgz"
tar czvf /var/www/html/$current $MWF_BASE_hosts
rm /var/www/html/Production-mwf-current.tgz
ln -s /var/www/html/$current /var/www/html/Production-mwf-current.tgz
current="Apache-Production-$currdate.tgz"
tar czvf /var/www/html/$current $MWF_APACHE_CONFIGS


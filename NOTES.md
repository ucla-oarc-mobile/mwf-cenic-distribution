mwf-cenic-distribution -- current issues
======================

There are currently issues with these deployment scripts:

1.  The apache /etc/httpd/conf.d/mwf.conf file is order sensitive.
  * For some reason when Berkeley is before UCLA, UCLA will not work
  * Need to separate individual host.conf files
  * Possibly prefix them with numbers to dictate order of loading.
  * Create a separate script to create the /etc/httpd/conf.d/#.host.mwf.conf files to version in github
1.  Need to do some fail-soft if the branch (master or stage) does not exist

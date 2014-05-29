mwf-cenic-distribution
======================

There are currently issues with this set up:
<pre>
1. The apache /etc/httpd/conf.d/mwf.conf file is order sensitive.
..* For some reason when Berkeley is before UCLA, UCLA will not work
..* Need to separate individual host.conf files
1. Need to do some fail-soft if the branch (master or stage) does not exist
</pre>

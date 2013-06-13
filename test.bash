#!/bin/bash
# configuration and replace function are in the config.txt file that is sourced below
# in addition to the lib.trap.sh library that needs to be sources first thing
. config.txt


DEBUG=false

echo "Starting.."
if [ $DEBUG = "true" ] ; then echo "Debuging on..." ; fi

# walk thru the hosts in $HOSTS and process the ones makred "active"
for host in "${!HOSTS[@]}"
do
  if [ $DEBUG = "true" ] ; then echo -n "$host is ";  fi
  if [ ${HOSTS[$host]} = "active" ]
  then
    if [ $DEBUG = "true" ] ; then echo "ACTIVE" ; fi
# 
    assoc_array_string=$(declare -p $host)
    if [ $DEBUG = "true" ] ; then echo "associative array for the host $host is defined with \"$assoc_array_string\""; fi
    eval "declare -A new_host_array="${assoc_array_string#*=}
# set up the variables for substitution and creation of the config files like
#  path=/var/www/html/mwf/ucla.prod
    for X in "${!new_host_array[@]}"
      do
        if [ $DEBUG = "true" ] ; then echo host variable = $new_host_array[$X] ; fi
        eval $X=${new_host_array[$X]}
      done
    
     for file_base in ${!config_files[@]}
       do
        if [ $DEBUG = "true" ] ; then echo "Original config string " ${config_files[$file_base]} ; fi
        file_in=$(replace ${config_files[$file_base]})
        if [ $DEBUG = "true" ] ; then echo ./templates/$file_base goes to  $(replace ${config_files[$file_base]}) ; fi
        if [ $DEBUG = "true" ] ; then echo "base = $file_base , file = $file_in" ; fi
# process template files ($TEMPLATEDIR/$file_base) and put them into the temp directory with the names $file_base.tmp
# remove the temp file before writing into it
     rm $TMPDIR/${file_base}.tmp
     while read line
       do
         replace $line
       done < $TEMPLATEDIR/$file_base >> $TMPDIR/${file_base}.tmp
# move the file into place
#     mv $TMPDIR/${file_base}.tmp $file_in
# remove .tmp files
#     rm $TMPDIR/${file_base}.tmp
       done
  else
   if [ $DEBUG = "true" ] ; then echo "NOT active" ; fi
  fi
done  

exit



  echo "$file_in"
  file_base=${file_in##*/}
   {
     sed \
     -e "s^\[\[path\]\]^${path}^g" \
     -e "s^\[\[directory\]\]^${direcotry}^g" \
     -e "s^\[\[site_url\]\]^${server_name}^g" \
     -e "s^\[\[url_path\]\]^${url_path}^g" \
     -e "s^\[\[site_name\]\]^${site_name}^g"\
     -e "s^\[\[server_aliases\]\]^${server_aliases}^g" \
     -e "s^\[\[docroot\]\]^${docroot}^g" \
     -e "s^\[\[server_name\]\]^${server_name}^g"
   } < $file_in > ${file_base}.temp
 done

echo "done."

exit


 {
 sed -e "s/\[\[url_path\]\]/${url_path}/g" | sed -e "s/\[\[path\]\]/${path}/g"
 } < templates/virtualhost.conf  > virtualhost.conf

# parse the comment free config file
while read line
   do 
   echo "input = " $line 
    eval  echo "$line"
   done < ./templates/alias.conf

echo "done"


#!/bin/bash

. config.txt
echo "Starting.."

for K in "${!config_files[@]}"
  do
   echo ./templates/$K = ${config_files[$K]}
  done


for file_in in ./templates/*
 do
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


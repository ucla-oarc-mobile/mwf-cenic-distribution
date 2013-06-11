#!/bin/bash

path=
directory=
site_url=http://m.ucla.edu
url_path=http://m.ucla.edu
server_name=ucla
server_aliases=ucla.prod
eval docroot=/var/www/html/mwf/${server_name}.prod

templates_files = ./templates/*
echo "Starting.."

for TEMPS in ./templates/*
  do
   {
    sed -e "s///" | sed -e 's/^[ \t]*//' | sed '/^$/d'
   } < config.txt  > temp.config.txt
  done
exit

# parse the comment free config file
while read line
   do 
   echo "input = " $line 
    eval  echo "$line"
   done < ./templates/alias.conf

echo "done"


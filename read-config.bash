#!/bin/bash

declare -A values

# errors
2>error.log

# remove comments and put comment free file in temp.config.txt
echo "Starting.."
{
 sed "s/#.*//" | sed -e 's/^[ \t]*//' | sed '/^$/d'
} < config.txt  > temp.config.txt


# parse the comment free config file
exec <temp.config.txt
while read line
   do 
   len=${#line}
   if [[ $len -gt 0  ]] 
      then 
         values[${line[0]}]=${line[1]}
   fi
   done

echo "output - "
for KEY in "${!values[@]}"
   do
      echo "$KEY ${values[$KEY]}"
   done
rm temp.config.txt

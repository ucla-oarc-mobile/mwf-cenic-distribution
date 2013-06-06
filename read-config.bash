#!/bin/bash

declare -A values

echo "Startin.."
exec<config.txt

while read line
   do 
   len=${#line}
   if [[ $len -gt 0  ]] 
      then 
         if [[ "$line" =~ .*\#.* ]]
            then
               echo -n
            else
               values[${line[0]}]=${line[1]}
         fi
   fi
   done

echo "output - "
for KEY in "${!values[@]}"
   do
      echo "$KEY ${values[$KEY]}"
   done

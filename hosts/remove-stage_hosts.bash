#!/bin/bash
# This is basically the "mirror" of the install_hosts.bash script. This will remove the config
# files and will remove a host files.  "remove" will actually remove the directory 
# tree that is the MWF instance. 
# 

#unset DEBUG
#DEBUG=true

# get the source directory of this script to source the config-stage.txt file first thing.  This is 
# convoluted to follow synlinks, etc

SOURCE="${BASH_SOURCE[0]}"
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; 
  do
  TARGET="$(readlink "$SOURCE")"
  if [[ $SOURCE == /* ]]; then
    if [ $DEBUG ] ; then echo "$LINENO: SOURCE '$SOURCE' is an absolute symlink to '$TARGET'" ; fi
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    if [ $DEBUG ] ; then echo "$LINENO: SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')" ; fi
# if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    SOURCE="$DIR/$TARGET"
  fi
done
if [ $DEBUG ] ; then echo "$LINENO: SOURCE is '$SOURCE'" ; fi
RDIR="$( dirname "$SOURCE" )"
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
if [ "$DIR" != "$RDIR" ]; then
  if [ $DEBUG ] ; then echo "$LINENO: DIR '$RDIR' resolves to '$DIR'" ; fi
fi
 if [ $DEBUG ] ; then echo "$LINENO: DIR is '$DIR'" ; fi

#
# configuration and replace function are in the config-stage.txt file that is sourced below
# in addition to the error trap routine that needs to be sourced first thing
. $DIR/config-stage.txt


echo "Starting.."
if [ $DEBUG ] ; then echo "$LINENO: Debuging on..." ; fi

# walk thru the hosts in $HOSTS and process the ones marked "remove"
for host in "${!HOSTS[@]}"
do
  if [ $DEBUG ] ; then echo -n "$LINENO: $host is ";  fi
  if [ ${HOSTS[$host]} = "remove" ]
  then
    if [ $DEBUG ] ; then echo "to be removed " ; fi
# 
    assoc_array_string=$(declare -p $host)
    if [ $DEBUG ] ; then echo "$LINENO: associative array for the host $host is defined with \"$assoc_array_string\""; fi
    eval "declare -A new_host_array="${assoc_array_string#*=}
# set up the variables for substitution and creation of the config files like
#  path=/var/www/html/mwf/ucla.prod
    for X in "${!new_host_array[@]}"
      do
        if [ $DEBUG ] ; then echo host variable = $new_host_array[$X] ; fi
        eval $X=${new_host_array[$X]}
      done


      if [ -f $docroot ]
        then
          if [ $DEBUG ] ; then echo " removing \"$docroot\""; fi
#    rm -Rf $docroot
        else
          echo $docroot  not found\!\!
      fi
  else
   if [ $DEBUG ] ; then echo " not removing" ; fi
  fi
done  

echo "remove_hosts done."

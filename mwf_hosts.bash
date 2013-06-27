#!/bin/bash
# get the source directory of this script to source the config.txt file first thing.  This is 
# convoluted to follow synlinks, etc

unset DEBUG
#export DEBUG=true

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
# configuration and replace function are in the config.txt file that is sourced below
# in addition to the error trap routine that needs to be sourced first thing
. $DIR/config.txt

echo "Starting.."
if [ $DEBUG ] ; then echo "$LINENO: Debuging on..." ; fi

echo "Running install_hosts.bash" 
# we use source so exit kills the shell, not a forked process
. $DIR/install_hosts.bash
echo "Running disable_hosts.bash" 
# we use source so exit kills the shell, not a forked process
. $DIR/disable_hosts.bash
echo "Running remove_hosts.bash" 
$DIR/remove_hosts.bash


if [ $DEBUG ] ; then echo "$LINENO: Done"; fi
exit

echo "Better never get here"

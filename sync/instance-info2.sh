#!/bin/bash

usage () {
        echo >&2 "$_NAME_ $_VERSION_ - $_PURPOSE_
Usage: $_SYNOPSIS_
Options:
	-t, type of instance to target (Valid types are Production and Staging)
	-s, subtype of instance to target (Valid subtypes are mwf)
        -h, usage (this output)"

        exit 1
}

[ $# -eq 0 ] && { echo >&2 "for usage, $_NAME_ -h"; exit 1; }

while getopts t:s:hl: options; do
        case $options in
                h) usage ;;
                t) OPTTYPE=$OPTARG ;;
		s) OPTSUBTYPE=$OPTARG ;;
        esac
done

if [ $OPTTYPE != "Production" ];then
if [ $OPTTYPE != "Staging" ];then
echo "Type must be either Production or Staging";exit 1
fi
fi




#Setup the critical paths, etc.
#EC2_HOME=/root/ec2-api-tools-1.6.6.4
#JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.9.x86_64/jre
PATH=$PATH:/root/ec2-api-tools-1.6.6.4/bin
export EC2_HOME
export JAVA_HOME
export PATH

#Create our temporary filenames
OUTPUT=$$OUTPUT
OUTPUT2=$$OUTPUT2
INSTANCEIDS=$$INSTANCEIDS

#Get the full list of instances from EC2, and extract the instance IDs
ec2-describe-instances -OAKIAJOXZRYS4ZSLESWFQ -W BO4EwTO6hJKjZQYsegQq+YZ2pobVHUTq0BMXNY9O --region us-west-1 > /tmp/$OUTPUT
cat /tmp/$OUTPUT | grep INSTANCE | awk '{print $2}' > /tmp/$INSTANCEIDS

#Loop through the instance IDs and extract the IDs which match both the specified type and subtype and output those IDs
for i in `cat /tmp/$INSTANCEIDS`;do 
NAME=`cat /tmp/$OUTPUT | grep TAG | grep $i | grep Name | awk '{print $5}'`
ID=`cat /tmp/$OUTPUT | grep INSTANCE | grep $i | awk '{print $4}'`
#TYPE=`cat /tmp/$OUTPUT | grep TAG | grep $i | grep Type | awk '{print $5}'`
TYPE=`cat /tmp/$OUTPUT | grep TAG | grep $i | grep Type | awk '{print $5}'`
SUBTYPE=`cat /tmp/$OUTPUT | grep TAG | grep $i | grep Subtype | awk '{print $5}'`
#if [ "$TYPE" = "Staging" ];then
if [ "$TYPE" = "$OPTTYPE" ];then
#if [ "$SUBTYPE" = "mwf" ];then
if [ "$SUBTYPE" = "$OPTSUBTYPE" ];then
echo $ID >> /tmp/$OUTPUT2
fi
fi
done
cat /tmp/$OUTPUT2
rm -f /tmp/$OUTPUT
rm -f /tmp/$OUTPUT2
rm -f /tmp/$INSTANCE-IDS


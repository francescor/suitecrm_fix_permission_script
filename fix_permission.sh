#!/bin/bash

# the following to be execute inside the DocumentRoot of a SuiteCRM installation
# to fix permissions

# Assure user is root:
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check that we are in a SuiteCRM DocumentRoot by
# checking files presence
FILES='suitecrm_version.php sugar_version.json config.php config_override.php'
for file in $FILES
do
  if [[ ! -f $file ]] ; then
    echo "This script must be executed in a SuiteCRM DocumentRoot, aborting."
    exit 1
  fi
done
# and checking directory presence
DIRS='data custom include modules log4php'
for dir in $DIRS
do
  if [[ ! -d $dir ]] ; then
    echo "This script must be executed in a SuiteCRM DocumentRoot, aborting."
    exit 1
  fi
done

DIR=`pwd`

echo "This script will fix permission of SuiteCRM DocumentRoot:  $DIR"
while true; do
    read -p "Proceed?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Fixing permission of SuiteCRM DocumentRoot: $DIR"


chown -R apache:apache $DIR
chmod -R 755           $DIR
chmod -R 775 cache custom modules themes data upload
chmod 775    config_override.php

echo "Done!"
echo "not better execute a 'Quick Repair and Rebuild' inside SuiteCRM admin interface"

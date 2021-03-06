#!/bin/bash


SITE_NAME=${1%/}
ARG_1=$2
ARG_2=$3


if [ ${ARG_1: -4} == ".tar" ]
        then
ARCHIVE=$ARG_1
echo "$ARCHIVE  -- tar "
        else
BACKUP=$ARG_1
echo "$BACKUP --sql"
fi

if [ ${ARG_2: -4} == ".sql" ]
        then
BACKUP=$ARG_2
echo "$BACKUP -- sql"
        else
ARCHIVE=$ARG_2
echo "$ARCHIVE --tar"
fi


if [ ${ARCHIVE: -4} == ".tar" ]
       then
if [ ${BACKUP: -4} == ".sql" ]
       then


tar -xvf $ARCHIVE $SITE_NAME


WPDBNAME=`grep DB_NAME $SITE_NAME/wp-config.php | cut -d \' -f 4`
WPDBUSER=`grep DB_USER $SITE_NAME/wp-config.php | cut -d \' -f 4`
WPDBPASS=`grep DB_PASSWORD $SITE_NAME/wp-config.php | cut -d \' -f 4`
HOST_PORT=`grep DB_HOST $SITE_NAME/wp-config.php | cut -d \' -f 4`

mysql -uroot -e "CREATE DATABASE $WPDBNAME"

if [ $HOST_PORT == "('DB_HOST', 'localhost')" ]
        then
mysql -p -u$WPDBUSER --password=$WPDBPASS $WPDBNAME < $BACKUP
        else
mysql -p -u$WPDBUSER --password=$WPDBPASS --host=$HOST_PORT $WPDBNAME < $BACKUP
fi


        else
echo "The MySQL dump extension is not correct"
exit 1

fi
        else
echo "The archive extension is not correct"
exit 1
fi

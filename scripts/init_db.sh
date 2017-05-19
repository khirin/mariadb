#!/bin/sh

MYSQL_PASSWORD=`echo ${DB_USER_PASSWORD} | base64 -d`
MYSQL_USER=${DB_USER}
MYSQL_DATABASE=${DATABASE}

echo -e "\n\t[i] Dropping defaults DBs ..."
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD < /conf/defaults_dbs_drop.sql \
	&& echo -e "\t[i] Defaults DBs successfully dropped !\n" \
	|| echo -e "\t[e] Defaults DBs drop failed !"

echo -e "\n\t[i] Importing $MYSQL_DATABASE data from ${MYSQL_DATABASE}_init.sql ..."
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < /conf/${MYSQL_DATABASE}_init.sql \
	&& echo -e "\t[i] $MYSQL_DATABASE data successfully imported !\n" \
	|| echo -e "\t[e] $MYSQL_DATABASE data import failed !\n"

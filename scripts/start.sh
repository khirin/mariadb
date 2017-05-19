#!/bin/sh
	echo -e "\n\t\t[#] start.sh [#]i\n"
if [ ! -f "/var/lib/mysql/init_ok" ]; then

# Initialize MySQL
	echo -e "\t[i] Initialize MySQL\n"
	mysql_install_db --user=mysql > /dev/null

# Variables Definition
	echo -e "\n\t[i] Variables definition"
	MYSQL_DATABASE=${DATABASE}
	MYSQL_USER=${DB_USER}
	MYSQL_PASSWORD=`echo ${DB_USER_PASSWORD} | base64 -d`
	MYSQL_ROOT_PASSWORD=`echo ${DB_ROOT_PASSWORD} | base64 -d`
	MYSQL_CLIENT_HOST=${CLIENT_HOST}

# Create temp file
	echo -e "\t[i] Create Temp File for initials requests"
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOF

	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo -e "\t[i] Creating database: $MYSQL_DATABASE"
	    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

	    if [ "$MYSQL_USER" != "" ]; then
		echo -e "\t[i] Creating user: $MYSQL_USER"
		echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'$MYSQL_CLIENT_HOST' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
		echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
	    fi
	fi

# Execute temp file
	echo -e "\t[i] Execute $tfile Temp File\n"
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
	rm -f $tfile

# Defaults DBs drop & data import in ${MYSQL_DATABASE} DB
        echo -e "\n\t[i] To drop defaults DBs & import $MYSQL_DATABASE data from ${MYSQL_DATABASE}_init.sql:"
        echo -e "\t[#] # /scripts/init_db.sh"

# Create init flag /var/lib/mysql/initdb_ok
	touch /var/lib/mysql/initdb_ok
else
        echo -e "\n\t[i] Settings already done ...\n"

fi

# Start MySQL
echo -e "\n\t[i] Starting MySQL ...\n"
exec /usr/bin/mysqld --user=mysql --console

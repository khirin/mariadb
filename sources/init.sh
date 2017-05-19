#!/bin/sh
        echo -e "\n\t\t[#] init.sh [#]"
if [ ! -f "/var/init_mariadb_ok" ]; then
# Directories
        echo -e "\n\t[i] Create directories"
        mkdir -p /var/lib/mysql /run/mysqld

# Permissions
        echo -e "\t[i] Set permissions"
        chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Create init flag /var/init_mariadb_ok
	echo -e "\t[i] Create init flag /var/init_mariadb_ok\n"
	touch /var/init_mariadb_ok
else
        echo -e "\n\t[i] Settings already done ...\n"

fi


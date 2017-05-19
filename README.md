## MariaDB Image

[![](https://images.microbadger.com/badges/image/khirin/mariadb.svg)](https://microbadger.com/images/khirin/mariadb "Get your own image badge on microbadger.com")

### Description
This is my minimal customized MariaDB image based on Alpine (with [my alpine image](https://hub.docker.com/r/khirin/alpine/)).
No root process.
The start.sh script will create the first database, a standard user that can interact from a specified host and network with the DB container.
If you have some sql script (to import data) to execute, put it at /conf/$DB_init.sql. It will be launch with the init_db.sh script.
I personaly use it with an nginx web container on a network created only for them.

### Packages
• Packages from [khirin/alpine](https://hub.docker.com/r/khirin/alpine/)
• mariadb
• mariadb-client

### Default Configuration
• Configuration from [khirin/alpine](https://hub.docker.com/r/khirin/alpine/)
• Default user (UID) : mysql (2000)
• Default group (GID) : mysql (2000)
• Default port : 3306
• Database name : mariadb
• DB Standard User : mariadb
• DB Standard Password : userpassword
• DB Root Password : rootpassword
**DB password must be set with [base64](https://www.base64encode.org/) coding.**

### Volumes
• /scripts (RO) : Start script and db init script. 
• /conf (RO) : SQL scripts.
• /var/lib/mysql (RW) : Where all database data will be store.
```shell
docker volume create --name data_mariadb
```
### Network
• mariadb_network : Network with only the mariadb container and a web container.
```shell
docker network create -o "com.docker.network.bridge.name=db-net" mariadb_network
```
### Usage
• Run : Will use the default configuration above.
• Build : Example of custom build. You can also directly modify the Dockerfile (I won't be mad, promis !)
• Create : Example of custom create. It is useless to publish the port, expose it is enough to other container(s) on the same network.

##### • Run
```shell
docker run --detach \
			-v "data_mariadb:/var/lib/mysql:rw" \
			-v "/my_script_folder:/scripts:ro" \
			-v "/my_conf_folder:/conf:ro" \
			--network mariadb-network \
			khirin/mariadb`
```

##### • Build
```shell
docker build --no-cache=true \
			--force-rm \
			--build-arg UID="2000" \
			--build-arg GID="2000" \
			--build-arg PORT="3306" \
			-t repo/mariadb .
```

##### • Create
```shell
docker create --hostname=mariadb \
			-v "data_mariadb:/var/lib/mysql:rw" \
			-v "/my_script_folder:/scripts:ro" \
			-v "/my_conf_folder:/conf:ro" \
			--env DATABASE="mariadb" \
			--env DB_USER="mariadb" \
			--env DB_USER_PASSWORD="dXNlcnBhc3N3b3Jk" \
			--env DB_ROOT_PASSWORD="cm9vdHBhc3N3b3Jk" \
			--env CLIENT_HOST="webclient.mariadb-network" \
			--name mariadb \
			--network mariadb-network \
			repo/mariadb
```

### Author
khirin : [DockerHub](https://hub.docker.com/u/khirin/), [GitHub](https://github.com/khirin?tab=repositories)

### Thanks
All my images are based on my personal knowledge and inspired by many projects of the Docker community.
If you recognize yourself in some working approaches, you might be one of my inspirations (Thanks!).

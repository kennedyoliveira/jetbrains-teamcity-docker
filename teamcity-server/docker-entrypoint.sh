#!/bin/sh
set -e

cat /etc/hosts

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/$TEAMCITY_POSTGRE_JDBC_DRIVER" ];
then
    echo "Downloading postgress JDBC driver..."
    curl -L https://jdbc.postgresql.org/download/$TEAMCITY_POSTGRE_JDBC_DRIVER -o $TEAMCITY_DATA_PATH/lib/jdbc/$TEAMCITY_POSTGRE_JDBC_DRIVER
fi

if [ "$1" = "migrate" ];
then
	echo "Migrating database ..."

	if [ ! -f "/tmp/teamcity_backup.zip" ];
	then
		echo "The TeamCity Backup not found! Run a new container passing the parameters -v <Path to Backup>:/tmp/teamcity_backup.zip"
		exit 1
	fi

	exec /opt/TeamCity/bin/maintainDB.sh restore -F /tmp/teamcity_backup.zip -T /tmp/database.postgresql.properties
else
	echo "Starting TeamCity Server $TEAMCITY_VERSION..."
	exec /opt/TeamCity/bin/teamcity-server.sh run
fi

JetBrains TeamCity docker image
===============
Distributed Build Management and Continuous Integration Server

By default, each TeamCity installation runs under a Professional Server license including 3 build agents. This license is provided for free with any downloaded TeamCity binary and gives you full access to all product features with no time limit. The only restriction is a maximum of 20 build configurations.

By pulling this image you accept the [JetBrains license agreement for TeamCity (Commercial License)] (https://www.jetbrains.com/teamcity/buy/license.html)

This docker image use an external postgres database that is easily setup with docker-compose instead of the internal database of TeamCity. (recommended for production usage)

This image also has a tool to migrate your TeamCity backup to the Dockerized version.

There are basically too ways to build and run this docker image.

The super easy way with docker compose and the easy way with docker images.

## The Super Easy Way

- Make sure you have docker-compose installed
- Clone the repository
	
  ````git clone https://github.com/kennedyoliveira/jetbrains-teamcity-docker.git````
- Set a environment variable to the postgres password
	- This password will be for the user *postgres*

  `export POSTGRES_PASSWORD=your-secret-password`
	
- Start the instances 

  `docker-compose up -d`

Done! You can access your localhost:8111 and there will be your new TeamCity!

## The Easy Way

- Make sure you have docker installed
- Pull the database image
	
  `docker pull kennedyoliveira/postgres-teamcity`
- Pull the server image
	
  `docker pull kennedyoliveira/teamcity-server`
- Run the postgres image, optionally making the postgres port accessible to host with (--publish 5432:5432) or -P to publish the port to a ephemeral port
	
  `docker run -d --name your-postgres-container-name -e POSTGRES_PASSWORD=your-postgres-password -v <path_to_postgres_data>:/var/lib/postgresql/data kennedyoliveira/postgres-teamcity`
- Run the TeamCity server image linked to the postgres
	- the `<path_to_teamcity_server_data>` is the full path where the data for the TeamCity server will be saved in YOUR host, also is where you will use to restore backup if you need

  `docker run -d --name your-teamcity-server -v <path_to_teamcity_server_data>:/var/lib/teamcity --link your-postgres-container-name:postgres --publish 8111:8111 kennedyoliveira/teamcity-server`
- Open your localhost:8111 and there will be your TeamCity!
- When selecting the database you can simple select Postgres, click in refresh jdbc driver, and use the credentials below:
	- host: postgres
	- username: teamcity
	- password: teamcity
	- database: teamcity

	Done!

### Migrating from normal TeamCity deploy to dockerized TeamCity

- Backup you current TeamCity by going to administration -> backup -> start backup (Select the information you want to backup and download the backup file)
- Clone the repository

	`git clone https://github.com/kennedyoliveira/jetbrains-teamcity-docker.git`
- Build and start the server
	
  `docker-compose up -d`
- Run a new container to import the backup
  - The `<path_to_teamcity_backup.zip>` is the full path to your teamcity backup done in the first step
  - The `<path_to_host_data>` is the full path where the data for the TeamCity server will be saved
	
  `docker run -ti --rm -v <path_to_teamcity_backup.zip>:/tmp/teamcity_backup.zip -v <path_to_host_data>:/var/lib/teamcity --link postgres-teamcity teamcity_teamcity-server migrate`
- After the command finish, you can restart your new TeamCity installation

	`docker-compose restart teamcity-server`

Done!
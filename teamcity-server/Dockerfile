FROM iron/java

MAINTAINER Kennedy Oliveira <kennedy.oliveira@outlook.com>

ENV TEAMCITY_VERSION 9.1.6
ENV TEAMCITY_DATA_PATH /var/lib/teamcity
ENV TEAMCITY_POSTGRE_JDBC_DRIVER postgresql-9.4.1207.jre7.jar

# Install curl
RUN apk update && apk add curl

# Clean APK cache
RUN rm -rf /var/cache/apk/*

# Create dir for TeamCity installation
RUN mkdir -p /opt

# Get and install teamcity
RUN curl -L http://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz | tar xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml 

# Create the directory for jdbc drivers
RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc

# Default teamcity port
EXPOSE 8111

# Data volume
VOLUME $TEAMCITY_DATA_PATH

# Copy configuration for migration
COPY ["database.postgresql.properties", "/tmp/database.postgresql.properties"]

# Copy started script
COPY ["docker-entrypoint.sh", "/docker-entrypoint.sh"]

# Fix permissions
RUN chmod 755 /docker-entrypoint.sh

# Set entry point to the starter script
ENTRYPOINT ["/docker-entrypoint.sh"]
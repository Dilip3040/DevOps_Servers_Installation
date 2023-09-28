#!/bin/bash

apt update -y

apt install default-jdk -y

# Install and Configure PostgreSQL

# Add the PostgreSQL repository

sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main"   /etc/apt/sources.list.d/pgdg.list'

# Add the PostgreSQL signing key.

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

# Install PostgreSQL

apt install postgresql-contrib -y

# Enable the postgresql database server

systemctl enable postgresql

# Start the database server

systemctl start postgresql

# Change the default PostgreSQL password.

passwd postgres

# Switch to the user postgres

su - postgres

cd

# Create a user named sonar.

createuser sonar

# Log in to PostgreSQL.

psql

# Set a password for the sonar user.

ALTER USER sonar WITH ENCRYPTED password 'Dilip@2320';

# Create a sonarqube database and set the owner to sonar.

CREATE DATABASE sonarqube OWNER sonar;

# Grant all the privileges on the sonarqube database to the sonar user.

GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;

# To exit PostgreSQL.

\q

# To Return to your non-root sudo user account.

exit

# SonarQube Installation

# Install unzip

apt install unzip -y

# Sonar Zip file

cd /opt

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.6.1.59531.zip

unzip sonarqube-9.6.1.59531.zip

mv sonarqube-9.6.1.59531.zip sonarqube

# Create a dedicated user and group for SonarQube, which can not run as the root user

# Create a sonar group.

groupadd sonar

# Create a sonar user and set /opt/sonarqube as the home directory.

useradd -d /opt/sonarqube -g sonar sonar

# Grant the sonar user access to the /opt/sonarqube directory.

sudo chown sonar:sonar /opt/sonarqube -R

clear

# Configure SonarQube

# Edit the SonarQube configuration file.

cd

vi /opt/sonarqube/conf/sonar.properties

<<comment

#sonar.jdbc.username=
#sonar.jdbc.password=
Uncomment the lines, and add the database user and password you created in Step 2.

sonar.jdbc.username=sonar
sonar.jdbc.password=Dilip@2320
Below those two lines, add the sonar.jdbc.url.

sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
Save and exit the file.

comment

# Edit the sonar script file.

cd

vi /opt/sonarqube/bin/linux-x86-64/sonar.sh

<<comment
#RUN_AS_USER="sonar"
Uncomment the line and change it to:
Save and exit the file.
comment

# Setup Systemd service

# Create a systemd service file to start SonarQube at system boot.

cd

vi /etc/systemd/system/sonar.service

<<comment
Paste the following lines to the file.

[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
 Save and exit the file.
comment

# Enable the SonarQube service to run at system startup.

systemctl enable sonar

#  Start the SonarQube service.

systemctl start sonar

# Check the service status.

systemctl status sonar

<<comment
Modify Kernel System Limits
SonarQube uses Elasticsearch to store its indices in an MMap FS directory. It requires some changes to the system defaults.
comment

# Edit the sysctl configuration file.

cd

vi /etc/sysctl.conf

<<comment
Add the following lines.

vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096

Save and exit the file.
comment

# Reboot the system to apply the changes.

sudo reboot

<<comment

Access SonarQube Web Interface
Access SonarQube in a web browser at your server's IP address on port 9000. For example:

http://IP:9000
Log in with username admin and password admin. SonarQube will prompt you to change your password.

comment


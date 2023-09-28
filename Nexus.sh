#!/bin/bash

apt update -y

apt install openjdk-8-jdk -y

cd /opt

wget https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.0.2-02-unix.tar.gz

tar -xvzf nexus-3.0.2-02-unix.tar.gz

mv nexus-3.0.2-02-unix nexus

# As a good security practice, it is not advised to run nexus service as root. so create new user called nexus and grant sudo access to manage nexus services

adduser nexus

visudo
# nexus   ALL=(ALL)       NOPASSWD: ALL

# Make nexus as root user for /opt/nexus 

chown -R nexus:nexus /opt/nexus

# Open /opt/nexus/bin/nexus.rc file and uncomment run_as_user and gives nexus as user.

vi /opt/nexus/bin/nexus.rc

# Add nexus as a service at boot time

ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

# Login as nexus user

su - nexus

cd

# start the nexus

cd /opt/nexus/bin

ls

./nexus start

# see the nexus status

./nexus status


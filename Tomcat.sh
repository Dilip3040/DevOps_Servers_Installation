#!/bin/bash

apt update

apt install default-jdk -y

cd /opt

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz

tar -xvzf apache-tomcat-9.0.80.tar.gz

mv apache-tomcat-9.0.80 tomcat

#Comment <valve section in above two context.xml files

vi /opt/tomcat/webapps/host-manager/META-INF/context.xml

vi /opt/tomcat/webapps/manager/META-INF/context.xml


cd 

vi /opt/tomcat/conf/tomcat-users.xml 
<<comment
Insert thes roles and users in tomcat-users.xml
<role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>
  <user username="deployer" password="deployer" roles="manager-script"/>
  <user username="tomcat" password="tomcat" roles="manager-gui"/> 
comment

cd

cd /opt/tomcat/bin

./startup.sh



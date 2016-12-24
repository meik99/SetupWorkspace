#!/bin/bash
if [ "$EUID" -ne 0 ] then
  echo "Script must have root priviliges"
  exit
fi

#set username
username="mrynkiewicz"

#update and upgrade system
apt update && apt upgrade -yf

#create temporary work folder
mkdir tmp
cd tmp

#download java 
#thanks to 
#http://stackoverflow.com/questions/10268583/downloading-java-jdk-on-linux-via-wget-is-shown-license-page-instead
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz
tar -xf jdk-8u112-linux-x64.tar.gz

#change owner of /opt to my username
chown -R $(username):$(username) /opt
chown -R $(username):$(username) /opt/*
mv jdk1.8.0_112 /opt/jdk

#export JAVA_HOME
echo "export JAVA_HOME=/opt/jdk/" >> /home/$(username)/.bashrc
source /home/$(username)/.bashrc

#add alias
echo "alias java='/opt/jdk/bin/java'" >> /home/$(username)/.bashrc
source /home/$(username)/.bashrc

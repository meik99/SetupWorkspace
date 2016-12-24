#!/bin/bash
if [ "$EUID" -ne 0 ] then
  echo "Script must have root priviliges"
  exit
fi

#set username
username="mrynkiewicz"
java_download="http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.tar.gz"
java_archive=${java_download##*/}
java_folder="jdk"
intelij_download="https://download.jetbrains.com/idea/ideaIU-2016.3.1.tar.gz"
intelij_archive=${intelij_download##*/}
intelij_folder="intelij"
webstorm_download="https://download.jetbrains.com/webstorm/WebStorm-2016.3.2.tar.gz"
webstorm_archive=${webstorm_download##*/}
webstorm_folder="webstorm"
userhome=/home/$username/
userbashrc=$userhome/.bashrc

#update and upgrade system
apt-get update && apt-get upgrade -yf

#create temporary work folder
mkdir tmp
cd tmp

#download java 
#thanks to 
#http://stackoverflow.com/questions/10268583/downloading-java-jdk-on-linux-via-wget-is-shown-license-page-instead
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $java_download
tar -xf $java_archive -C $java_folder

#change owner of /opt to my username
chown -R $username:$username /opt
chown -R $username:$username /opt/*
mv $java_folder /opt/

#export JAVA_HOME
echo "export JAVA_HOME=/opt/$java_folder/" >> $userbashrc
source $userbashrc

#add alias
echo "alias java='/opt/$java_folder/bin/java'" >> $userbashrc
source $userbashrc

#download chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb

# check if succeeded, if not install missing depenedencies
if [ $? -ne 0 ]
  then apt install -f
  dpkg -i google-chrome*.deb
fi

#download intelij
wget --no-check-certificate --no-cookies $intelij_download
#extract intelij
tar -xf $intelij_archive -C $intelij_folder
#move intelij to /opt
mv $intelij_folder /opt/
#add alias
echo "alias intelij='sh /opt/$intelij_folder/bin/intelij.sh'" >> $userbashrc
source $userbashrc

#download webstorm
wget --no-check-certificate --no-cookies $webstorm_download
#extract webstorm
tar -xf $webstorm_archive -C $webstorm_folder
#move webstorm to /opt
mv $webstorm_folder /opt/
#add alias
echo "alias webstorm='sh /opt/$webstorm_folder/bin/webstorm.sh'" >> $userbashrc
source $userbashrc

#delete tmp folder
cd ..
rm -rf ./tmp

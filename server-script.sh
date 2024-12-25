#! /bin/bash

sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install maven -y

if [-d "addressbook"]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/ADSRESSBOOK-V1
    git pull origin sept
elsw
    git clone https://github.com/karthik-mv/addressbook-v1.git
fi

cd /home/ec2-user/ADDRESSBOOK-v1

mvn package
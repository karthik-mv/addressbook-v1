#! /bin/bash

#sudo yum install java-1.8.0-openjdk-devel -y
#sudo yum install git -y
#sudo yum install maven -y

sudo yum install docker -y
sudo systemctl start docker

if [-d "addressbook"]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/addressbook
    git pull origin docker
else
    git clone https://github.com/karthik-mv/addressbook-v1.git
fi

cd /home/ec2-user/addressbook
git checkout docker
sudo docker build -t $1:$2 /home/ec2-user/addressbook    #$1 represents repository name $2 represents jenkins build no

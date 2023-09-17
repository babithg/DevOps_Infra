#!/bin/bash
sudo export DEBIAN_FRONTEND=noninteractive
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt update -y
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
sudo usermod -aG docker $USER
sudo systemctl enable docker 
sudo systemctl start docker 
sudo docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
echo "Installed the SonarQube server and initial-script completed" >>/tmp/welcome.txt
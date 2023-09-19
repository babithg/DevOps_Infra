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

sudo docker pull releases-docker.jfrog.io/jfrog/artifactory-oss:latest
sudo mkdir -p /jfrog/artifactory/var/etc/
sudo cd /jfrog/artifactory/var/etc/
sudo touch ./system.yaml
sudo chown -R 1030:1030 /jfrog/artifactory/var
sudo docker run \
    --name artifactory \
    -v /jfrog/artifactory/var/:/var/opt/jfrog/artifactory \
    -p 8081:8081 \
    -p 8082:8082 \
    -d releases-docker.jfrog.io/jfrog/artifactory-oss:latest

echo "[`date +%Y_%m_%d`] Installed the artifactory server and initial-script completed" >>/tmp/devops_tools_status
#!/bin/bash
sudo export DEBIAN_FRONTEND=noninteractive
sudo apt update -y
sudo apt upgrade -y
sudo apt install openjdk-17-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y 
sudo apt-get install jenkins -y
echo "[`date +%Y_%m_%d`] Installed the jenkins server and initial-script completed" >>/tmp/devops_tools_status
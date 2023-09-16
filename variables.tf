variable "aws_region" {
    default = "ap-south-1"
    description = "Region where the AWS Resource getting created"
}

variable "jenkins_server" {
    default = {
        ami = "ami-053b0d53c279acc90"
        instance_type = "t2.micro"
        tag_name = "Jenkins_Server"
        disk_size = 29
        user = "ec2-user"
    }
    description = "Jenkins Server EC2 Configuration"
}

variable "sonarqube_server" {
    default = {
        ami = "ami-053b0d53c279acc90"
        instance_type = "t2.micro"
        tag_name = "SonarQube_Server"
        disk_size = 8
        user = "ec2-user"
    }
    description = "SonarQube Server EC2 Configuration"
}

variable "devops_server" {
    default = {
        ami = "ami-04cb4ca688797756f"
        instance_type = "t2.micro"
        tag_name = "DevOps_Server"
        disk_size = 8
        user = "ec2-user"
    }
    description = "DevOps Server EC2 Configuration"
}

variable "devops_tools" {
    default = {
        jenkins_install = <<-EOF
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
        echo "Installed the jenkins server and initial-script completed" >>/tmp/welcome.txt
        EOF

        sonarqube_install = <<-EOF
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
        EOF
    }
}
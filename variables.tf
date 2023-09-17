variable "aws_region" {
    default = "ap-south-1"
    description = "Region where the AWS Resource getting created"
}

variable "jenkins_server" {
    default = {
        ami = "ami-0f5ee92e2d63afc18"
        instance_type = "t2.medium"
        tag_name = "Jenkins_Server"
        disk_size = 29
        user = "ec2-user"
    }
    description = "Jenkins Server EC2 Configuration"
}

variable "sonarqube_server" {
    default = {
        ami = "ami-0f5ee92e2d63afc18"
        instance_type = "t2.medium"
        tag_name = "SonarQube_Server"
        disk_size = 8
        user = "ec2-user"
    }
    description = "SonarQube Server EC2 Configuration"
}

variable "artifactory_server" {
    default = {
        ami = "ami-0f5ee92e2d63afc18"
        instance_type = "t2.medium"
        tag_name = "Artifactory_Server"
        disk_size = 8
        user = "ec2-user"
    }
    description = "Artifactory Server EC2 Configuration"
}

variable "devops_tools" {
    default = {
        jenkins_install = <<-EOF
        sudo apt install -y git
        git clone https://github.com/babithg/DevOps_Infra.git
        cd DevOps_Infra/devops_tools
        /bin/bash jenkins_install.sh
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

        artifactory_install = <<-EOF
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

        docker pull docker.bintray.io/jfrog/artifactory-oss:latest
        sudo mkdir -p /jfrog/artifactory
        sudo chown -R 1030 /jfrog/
        docker run --name artifactory -d \
        -p 8081:8081 \
        -p 8082:8082 \
        -v /jfrog/artifactory:/var/opt/jfrog/artifactory \
        docker.bintray.io/jfrog/artifactory-oss:latest
        EOF
    }
}
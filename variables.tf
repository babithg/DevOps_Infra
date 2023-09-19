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
        instance_type = "t2.xlarge"
        tag_name = "Artifactory_Server"
        disk_size = 8
        user = "ec2-user"
    }
    description = "Artifactory Server EC2 Configuration"
}

variable "devops_tools" {
    default = {
        jenkins_install = <<-EOF
        #!/bin/bash
        hostname jenkins_master
        echo "jenkins_master" >/etc/hostname
        sudo apt install -y git
        git clone https://github.com/babithg/DevOps_Infra.git /tmp/setup/
        /bin/bash /tmp/setup/devops_tools/jenkins_install.sh
        EOF

        sonarqube_install = <<-EOF
        #!/bin/bash
        hostname sonarqube
        echo "sonarqube" >/etc/hostname
        sudo apt install -y git
        git clone https://github.com/babithg/DevOps_Infra.git /tmp/setup/
        /bin/bash /tmp/setup/devops_tools/sonarqube_install.sh
        EOF

        artifactory_install = <<-EOF
        #!/bin/bash
        hostname artifactory
        echo "artifactory" >/etc/hostname
        sudo apt install -y git
        git clone https://github.com/babithg/DevOps_Infra.git /tmp/setup/
        /bin/bash /tmp/setup/devops_tools/artifactory_install.sh
        EOF
    }
}
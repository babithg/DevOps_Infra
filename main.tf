
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "jenkins_server" {
    ami = var.jenkins_server.ami
    instance_type = var.jenkins_server.instance_type
    tags = {
      Name = var.jenkins_server.tag_name
    }
    root_block_device{
      volume_size = var.jenkins_server.disk_size
    }
    connection{
      host = self.public_ip
      user = var.jenkins_server.user
    }
    security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_jenkins.name]
    user_data = var.devops_tools.jenkins_install
    }

resource "aws_instance" "sonarqube_server" {
    ami = var.sonarqube_server.ami
    instance_type = var.sonarqube_server.instance_type
    tags = {
      Name = var.sonarqube_server.tag_name
    }
    root_block_device{
      volume_size = var.sonarqube_server.disk_size
    }
    connection{
      host = self.public_ip
      user = var.sonarqube_server.user
    }
    security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_sonarqube.name]
    user_data = var.devops_tools.sonarqube_install
    }

resource "aws_instance" "devops_server" {
  ami = var.devops_server.ami
  instance_type = var.devops_server.instance_type
  tags = {
    Name = var.devops_server.tag_name
  }
  root_block_device{
    volume_size = var.devops_server.disk_size
  }
  connection{
    host = self.public_ip
    user = var.devops_server.user
  }
  security_groups = [aws_security_group.allow_ssh.name]
}

resource "aws_security_group" "allow_jenkins" {
  name = "jenkins-ports"
  description = "Allow access to Jenkins UI"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_security_group" "allow_artifactory" {
  name = "artifactory-ports"
  description = "Allow access to Artifactory UI"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_security_group" "allow_sonarqube" {
  name        = "allow-sonarqube"
  description = "Allow SSH access from anywhere"

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH access from anywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = {
    Jenkins_Server = aws_instance.jenkins_server.public_ip
    DevOps_Server = aws_instance.devops_server.public_ip
  }
}
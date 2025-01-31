resource "aws_instance" "jenkins" {
  ami           = "ami-0c02fb55956c7d316" # Replace with your AMI ID
  instance_type = "t2.medium" # Jenkins requires more resources
  subnet_id     = var.public_subnets[0]
  security_groups = [var.jenkins_security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y openjdk-11-jdk
              wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt update
              sudo apt install -y jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}
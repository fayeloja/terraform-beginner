resource "aws_instance" "prometheus" {
  ami           = "ami-0c02fb55956c7d316" # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.public_subnets[0]
  security_groups = [var.monitoring_security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 9090:9090 --name prometheus prom/prometheus
              EOF
}

resource "aws_instance" "grafana" {
  ami           = "ami-0c02fb55956c7d316" # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.public_subnets[0]
  security_groups = [var.monitoring_security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 3000:3000 --name grafana grafana/grafana
              EOF
}

output "prometheus_url" {
  value = "http://${aws_instance.prometheus.public_ip}:9090"
}

output "grafana_url" {
  value = "http://${aws_instance.grafana.public_ip}:3000"
}
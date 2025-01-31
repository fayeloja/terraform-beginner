resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "production-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id
  # Add ingress/egress rules for ALB
}

resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.main.id
  # Add ingress/egress rules for EC2
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2.id
}

resource "aws_security_group" "db" {
  vpc_id = aws_vpc.main.id
  # Add ingress/egress rules for RDS
}

resource "aws_security_group" "monitoring" {
  vpc_id = aws_vpc.main.id
  # Add ingress/egress rules for Prometheus and Grafana
}

resource "aws_security_group" "jenkins" {
  vpc_id = aws_vpc.main.id
  # Add ingress/egress rules for Jenkins
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}

output "monitoring_security_group_id" {
  value = aws_security_group.monitoring.id
}

output "jenkins_security_group_id" {
  value = aws_security_group.jenkins.id
}
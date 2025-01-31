output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "prometheus_url" {
  value = module.monitoring.prometheus_url
}

output "grafana_url" {
  value = module.monitoring.grafana_url
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "alb" {
  source = "./modules/alb"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  security_groups = [module.vpc.alb_security_group_id]
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  security_groups = [module.vpc.ec2_security_group_id]
  alb_target_group_arn = module.alb.alb_target_group_arn
}

module "rds" {
  source = "./modules/rds"

  private_subnets       = module.vpc.private_subnets
  db_username           = var.db_username
  db_password           = var.db_password
  db_security_group_id  = module.vpc.db_security_group_id
}

module "monitoring" {
  source = "./modules/monitoring"

  public_subnets             = module.vpc.public_subnets
  monitoring_security_group_id = module.vpc.monitoring_security_group_id
}

module "jenkins" {
  source = "./modules/jenkins"

  public_subnets          = module.vpc.public_subnets
  jenkins_security_group_id = module.vpc.jenkins_security_group_id
}
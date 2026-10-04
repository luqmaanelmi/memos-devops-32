module "ecr" {
  source = "./modules/ecr"
}

module "vpc" {
  source                = "./modules/vpc"
  vpc_name              = var.project_name
  cidr_block            = var.vpc_cidr
  public_subnet_cidr_1  = var.public_subnet_cidr_1
  public_subnet_cidr_2  = var.public_subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

module "iam" {
  source             = "./modules/iam"
  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  ecr_repository_arn = module.ecr.repository_arn
  github_org_repo    = var.github_org_repo
  github_branch      = var.github_branch
  depends_on         = [module.ecr]
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
  root_domain = var.root_domain
  depends_on  = [module.iam]
}

module "alb" {
  source                = "./modules/alb"
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_1_id    = module.vpc.public_subnet_1_id
  public_subnet_2_id    = module.vpc.public_subnet_2_id
  alb_security_group_id = module.vpc.alb_security_group_id
  certificate_arn       = module.acm.certificate_arn
  app_port              = var.app_port
  depends_on            = [module.vpc, module.acm, module.iam]
}

module "ecs" {
  source                = "./modules/ecs"
  project_name          = var.project_name
  aws_region            = var.aws_region
  vpc_id                = module.vpc.vpc_id
  private_subnet_1_id   = module.vpc.private_subnet_1_id
  private_subnet_2_id   = module.vpc.private_subnet_2_id
  ecs_security_group_id = module.vpc.ecs_security_group_id
  execution_role_arn    = module.iam.ecs_execution_role_arn
  task_role_arn         = module.iam.ecs_task_role_arn
  container_image       = module.ecr.repository_url
  target_group_arn      = module.alb.target_group_arn
  app_port              = var.app_port
  task_cpu              = var.task_cpu
  task_memory           = var.task_memory
  depends_on            = [module.alb, module.ecr, module.iam]
}
module "route53" {
  source       = "./modules/route53"
  domain_name  = var.root_domain
  subdomain    = var.subdomain
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
  depends_on   = [module.alb, module.iam]
}
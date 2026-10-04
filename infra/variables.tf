variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "root_domain" {
  description = "Root domain name"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the app"
  type        = string
}

variable "domain_name" {
  description = "Full domain name"
  type        = string
}

variable "github_org_repo" {
  description = "GitHub org/repo for OIDC"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 5230
}

variable "task_cpu" {
  description = "ECS task CPU"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "ECS task memory"
  type        = number
  default     = 1024
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "Public subnet 1 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "Public subnet 2 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_1" {
  description = "Private subnet 1 CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
  description = "Private subnet 2 CIDR"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_1" {
  description = "First AZ"
  type        = string
  default     = "eu-west-2a"
}

variable "availability_zone_2" {
  description = "Second AZ"
  type        = string
  default     = "eu-west-2b"
}
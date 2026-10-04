variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ECR repository ARN"
  type        = string
}

variable "github_org_repo" {
  description = "GitHub org/repo"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch"
  type        = string
}
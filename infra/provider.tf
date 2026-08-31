terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "luqmaan-memos-tfstate-2026"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
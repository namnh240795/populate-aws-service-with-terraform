terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source      = "./modules/vpc"
  cidr        = var.cidr
  vpc_name    = var.vpc_name
  environment = var.environment
}

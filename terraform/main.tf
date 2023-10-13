terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "yellowcandle-terraform-state-store"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "yellowcandle-terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "terraform-state-store" {
  bucket = "yellowcandle-terraform-state-store"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "yellowcandle-terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


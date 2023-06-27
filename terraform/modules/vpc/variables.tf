

variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "The region you want to deploy the infratructure"
}

variable "cidr" {
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC"
}

variable "private_subnets" {
  description = "The CIDR block for the private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"] 
}

variable "public_subnets" {
  description = "The CIDR block for the public subnets"
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  description = "A list of availability zones in the region"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "vpc_name" {
  description = "The name of the VPC"
  default     = "namnh240795-vpc"
}

variable "environment" {
  description = "The environment for the VPC"
  default     = "dev"
}
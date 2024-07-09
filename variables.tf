######################
## Global variables ##  
######################
variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "ap-south-1"
}

variable "common_tags" {
  default = {
    Project     = "VPC Setup"
    Environment = "Production"
  }
}
variable "vpc_name" {
  type        = string
  description = "The name of the VPC."

}
#####################
## AWS Networking  ##  
#####################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

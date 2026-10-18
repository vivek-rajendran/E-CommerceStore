variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type        = string
  description = "Name of your existing AWS EC2 Key Pair for SSH access"
}

variable "mongo_uri" {
  type        = string
  description = "Your full MongoDB Atlas connection string"
  sensitive   = true
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
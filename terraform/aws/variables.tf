variable "infra_name" {
  description = "must be unique inside a billing account"
}

variable "aws_region" {
  description = "target aws region"
}

variable "vpc_cidr" {
  description = "the cidr to use for the vpc"
}

variable "public_subnet_a_cidr" {
  description = "the cidr to use for the first public subnet"
}

variable "public_subnet_a_az" {
  description = "the az for the first public subnet"
  default = "us-west-2a"
}

variable "coreos_stable_hvm_ami" {
  default = "ami-4c49f22c"
}

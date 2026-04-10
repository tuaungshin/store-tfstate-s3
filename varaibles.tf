 # Variables for AWS infrastructure module

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "testing-vpc"
}

variable "region" {
  type = string
  default = "ap-southeast-1"
}
variable "az_a" {
  type        = string
  description = "AWS zone used for all resources"
  default     = "ap-southeast-1a"
}

variable "az_b" {
  type        = string
  description = "AWS zone used for all resources"
  default     = "ap-southeast-1b"
}

variable "aws-keypair" {
  type = string
  description = "aws ec2 key pair"
  default = "myec2-keypair"
  
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t2.nano"
}
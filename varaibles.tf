 # Variables for AWS infrastructure module

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "testing-vpc"
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
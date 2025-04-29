variable "vpc_id" {
  description = "VPC ID where the subnet will be created"
  type        = string
}

variable "gateway_id" {
  description = "Main Internet Gateway ID"
  type        = string
}
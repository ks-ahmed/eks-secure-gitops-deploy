variable "name" {
  description = "Project or environment name prefix (used in resource naming)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones to distribute resources across"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs (should match length of AZs)"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs (should match length of AZs)"
  type        = list(string)
}

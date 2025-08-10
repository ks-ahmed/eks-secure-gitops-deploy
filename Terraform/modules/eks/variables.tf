variable "name" {
  description = "Name of the EKS cluster and related resources"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS control plane"
  type        = string
}

variable "eks_node_role_arn" {
  description = "ARN of the IAM role for the EKS worker nodes"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS cluster and nodes"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster and nodes will be deployed"
  type        = string
}

variable "worker_node_cidr" {
  description = "CIDR block(s) used by worker nodes to allow communication with EKS control plane"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}


variable "worker_node_cidr" {
  description = "CIDR block(s) used by worker nodes to allow communication with EKS control plane"
  type        = list(string)
}

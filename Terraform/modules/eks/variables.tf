variable "name" {
  description = "Base name for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "worker_node_cidr" {
  description = "CIDR blocks allowed for worker node access"
  type        = list(string)
}

variable "eks_cluster_sg_ingress_rules" {
  description = "Ingress rules for EKS cluster security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = optional(list(string))
  }))
  default = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow worker nodes to access API server"
      cidr_blocks = []
    }
  ]
}

variable "eks_node_sg_ingress_rules" {
  description = "Ingress rules for EKS node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = optional(list(string))
    self        = optional(bool)
  }))
  default = [
    {
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      description = "Allow NodePort services"
      cidr_blocks = []
    },
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all node-to-node communication"
      self        = true
    }
  ]
}

variable "egress_rules" {
  description = "Egress rules for security groups"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "cluster_version" {
  description = "EKS Cluster version"
  type        = string
  default     = "1.27"
}

variable "eks_cluster_role_arn" {
  description = "ARN for the EKS cluster IAM role"
  type        = string
}

variable "eks_node_role_arn" {
  description = "ARN for the EKS node IAM role"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS nodes and cluster"
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
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}

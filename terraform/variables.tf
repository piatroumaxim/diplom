variable region {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable esc_agent_policy_arn {
  type        = string
  default     = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  description = "AWS iam policy for ecs agent"
}

variable image_id {
  type        = string
  default     = "ami-091aa67fccd794d5f"
  description = "image id for ec2 instances in asg"
}

variable instance_type {
  type        = string
  default     = "t2.micro"
  description = "type ec2 instance"
}

variable desired_instances {
  type        = number
  default     = 2
  description = "desired count ec2 instances in cluster"
}

variable min_instances {
  type        = number
  default     = 2
  description = "min count ec2 instances in cluster"
}

variable max_instances {
  type        = number
  default     = 4
  description = "max count ec2 instances in cluster"
}

variable tag_version {
  type        = string
  default     = ""
  description = "TAG app in github"
}

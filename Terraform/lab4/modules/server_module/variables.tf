variable "inbound_rules" {
  description = "The inbound rules for the security group in format of a map of objects with keys from_port, to_port, protocol, and cidr_blocks"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
variable "outbound_rules" {
  description = "The outbound rules for the security group in format of a map of objects with keys from_port, to_port, protocol, and cidr_blocks"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "security_group_name" {
  description = "The name of the security group to create"
  type        = string
}

variable "security_group_description" {
  description = "The description of the security group to create"
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "The ID of the VPC to launch the EC2 instance in"
  type        = string
}


variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(any)
  default     = null
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"
}


variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource in format of a map of strings"
  type        = map(string)
  default     = {}
}

variable "is-public" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = false
}

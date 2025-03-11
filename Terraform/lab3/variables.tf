variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type = string
}

variable "nat_gw_name" {
  description = "Name of the NAT Gateway"
  type = string
}

variable "subnets" {
  description = "List of maps for subnets"
  type = list(object({
    name            = string
    cidr_block      = string
    availability_zone = string
    is_public      = bool
  }))
}

# --

variable "sg-name" {
  description = "Name of the security group"
  type = list(string)
}

variable "inbound_rules" {
  description = "List of maps for inbound rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "outbound_rules" {
  description = "List of maps for outbound rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "key_name" {
  description = "Name of the key pair"
  type = string
}


variable "instances" {
  description = "List of maps for instances"
  type = list(object({
    name           = string # name of the instance
    ami            = string # id of the AMI
    instance_type  = string # type of the instance
    subnet_index   = number # index of the subnet
    security_group = string # name of the security group
    associate_public_ip_address = bool # associate public IP address
    user_data      = string # user data
  }))
}
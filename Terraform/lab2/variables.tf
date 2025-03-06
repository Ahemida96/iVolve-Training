variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnets"
  type        = string
}

variable "subnet_name" {
  description = "The public subnet name"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  type				= string
  default   	= "t2.micro"
  
}

variable "key_name" {
  type				= string
  default   	= "terraform"
}

variable "sns_topic_name" {
  type				= string
  default   	= "HighCPUAlarm"
  
}

variable "sns_protocol" {
  type				= string
  default   	= "email"
  
}

variable "alarm_name" {
  type				= string
  default   	= "CPUAlarm"
  
}

variable "comparison_operator" {
  type				= string
  default   	= "GreaterThanOrEqualToThreshold"
  
}

variable "evaluation_periods" {
  type				= number
  default   	= 1
}

variable "metric_name" {
  type				= string
  default   	= "CPUUtilization"
  
}

variable "namespace" {
  type				= string
  default   	= "AWS/EC2"
  
}

variable "threshold" {
  type				= number
  default   	= 80
}

variable "statistic" {
  type				= string
  default   	= "Average"
}

variable "period" {
  type				= number
  default   	= 300
}

variable "email" {
  type				= string
}
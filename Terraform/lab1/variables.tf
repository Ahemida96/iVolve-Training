variable "subnet_cidr_block" {
  description = "The CIDR block for the subnets"
  type        = list(string)
}

variable "subnet_name" {
  description = "The public subnet name"
  type        = list(string)
}

variable "availability_zone" {
  description = "The availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "key_name" {
  type				= string
  default   	= "terraform"
}

variable "engine" {
  type				= string
  default   	= "mysql"
}

variable "engine_version" {
  type				= string
  default   	= "5.7"
}

variable "instance_class" {
  type				= string
  default   	= "db.t2.micro"
}

variable "password" {
  type				= string
}

variable "username" {
  type				= string
}

variable "name" {
  type				= string
  default   	= "mydb"
}

variable "allocated_storage" {
  type				= number
  default   	= 20
}

variable "storage_type" {
  type				= string
  default   	= "gp2"
}

variable "skip_final_snapshot" {
  type				= bool
  default   	= true
}

variable "publicly_accessible" {
  type				= bool
  default   	= false
}

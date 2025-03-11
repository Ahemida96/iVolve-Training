variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks. Must be the same length as availability_zones"
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  type = list(string)
}

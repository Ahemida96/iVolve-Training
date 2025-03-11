data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS Account ID for official Ubuntu images
}

#----------------------Security Groups-----------------------
resource "aws_security_group" "this" {
  for_each = var.sg-name
  vpc_id = aws_vpc.main.id
  name = each.value

  dynamic "ingress" {
    for_each = var.inbound_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.outbound_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = each.value
  }
}

# ---------------------- Create Pair Key ----------------------
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename        = "~/.ssh/${var.key_name}.pem"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0400"
}

#---------------------------Create EC2 Instances----------------------------------

locals {
  subnet_ids = [for subnet in var.subnets.subnet_name : aws_subnet[subnet].id]
  instances = {
    for instance in var.instances : instance.name => {
      ami           = instance.ami
      instance_type = instance.instance_type
      subnet_id     = local.subnet_ids[instance.subnet_index]
      security_groups = [aws_security_group[instance.security_group].id]
      key_name      = aws_key_pair.key_pair.key_name
      associate_public_ip_address = instance.associate_public_ip_address
    }
  }
}

resource "aws_instance" "this" {
  for_each        = local.instances
  ami             = each.value.ami
  instance_type   = each.value.instance_type
  subnet_id       = each.value.subnet_id
  security_groups = each.value.security_groups
  key_name        = each.value.key_name
  associate_public_ip_address = each.value.associate_public_ip_address

  tags = {
    Name = each.key
  }
}

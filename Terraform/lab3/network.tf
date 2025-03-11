#---------------------Create VPC-----------------------------
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

#---------------------Internet Gateway-----------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.igw_name
  }
}

#----------------------Create Subnets-----------------------------

resource "aws_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.is_public

  tags = {
    Name = each.value
  }
}

resource "aws_route_table" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = eac.value.is_public ? aws_internet_gateway.this.id : null
    nat_gateway_id = each.value.is_public ? null : aws_nat_gateway.this.id
  }

  tags = {
    Name = each.value
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

#----------------------NAT Gateway-----------------------------
resource "aws_eip" "nat_eip" {
  associate_with_private_ip = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_gw_name
  }
  depends_on = [aws_internet_gateway.this]
}

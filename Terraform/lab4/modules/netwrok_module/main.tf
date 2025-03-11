locals {
  len_public_subnets  = length(var.public_subnets)
}

resource "aws_subnet" "public-subnet" {
  count                   = local.len_public_subnets > 0 && local.len_public_subnets >= length(var.availability_zones) ? local.len_public_subnets : 0
  vpc_id                  = var.vpc_id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_names[count.index] != "" ? var.public_subnet_names[count.index] : "Public Subnet ${count.index + 1}"
  }

}

resource "aws_route_table" "public" {
  count  = local.len_public_subnets > 0 && local.len_public_subnets >= length(var.availability_zones) ? local.len_public_subnets : 0
  vpc_id = var.vpc_id
  tags = {
    Name = "Public Route Table ${count.index + 1}"
  }

}

resource "aws_route_table_association" "public" {
  count          = local.len_public_subnets > 0 && local.len_public_subnets >= length(var.availability_zones) ? local.len_public_subnets : 0
  subnet_id      = element(aws_subnet.public-subnet[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

resource "aws_route" "public-internet-gateway" {
  count                  = local.len_public_subnets > 0 && local.len_public_subnets >= length(var.availability_zones) ? local.len_public_subnets : 0
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}


resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_vpc" "main" {
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block[0]
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name[0]
    } 
}

resource "aws_subnet" "private_subnet" {
	vpc_id                  = aws_vpc.main.id
	cidr_block              = var.subnet_cidr_block[1]
	availability_zone       = var.availability_zone
	map_public_ip_on_launch = false

	tags = {
		Name = var.subnet_name[1]
		} 
}

resource "aws_subnet" "private_subnet2" {
	vpc_id                  = aws_vpc.main.id
	cidr_block              = var.subnet_cidr_block[2]
	availability_zone       = "us-east-1b"
	map_public_ip_on_launch = false

	tags = {
		Name = "private2"
		}
}

resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "main"
	}
}

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.this.id
	}
}

resource "aws_route_table" "private" {
	vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private2" {
	vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public" {
	subnet_id      = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
	subnet_id      = aws_subnet.private_subnet.id
	route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
	subnet_id      = aws_subnet.private_subnet2.id
	route_table_id = aws_route_table.private2.id
}

resource "aws_db_subnet_group" "this" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet2.id]
}

resource "aws_security_group" "this" {
	vpc_id = aws_vpc.main.id

	ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "rds-sg" {
	vpc_id = aws_vpc.main.id

	ingress {
		from_port   = 3306
		to_port     = 3306
		protocol    = "tcp"
		security_groups = [aws_security_group.this.id]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "rds-sg"
	}
}

locals {
  instances = {
    instance1 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
    }
  }
}

resource "aws_instance" "this" {

  for_each        = local.instances
  ami             = each.value.ami
  instance_type   = each.value.instance_type
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.this.id]
  key_name        = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "public-{$each.key}"
  }

	provisioner "local-exec" {
		command = "echo ${self.public_ip} >> ec2-ip.txt"
	}
}


# Create RDS Database Instance
resource "aws_db_instance" "db" {

  allocated_storage    = var.allocated_storage
  identifier           = var.name
  storage_type         = var.storage_type
  skip_final_snapshot  = var.skip_final_snapshot
  publicly_accessible  = var.publicly_accessible
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.this.name
}


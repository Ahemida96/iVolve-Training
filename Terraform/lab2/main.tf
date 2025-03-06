resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.main.id

	tags = {
		Name = "igw"
	}
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
    } 
}

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.this.id
	}
}

resource "aws_route_table_association" "public" {
	subnet_id      = aws_subnet.public_subnet.id
	route_table_id = aws_route_table.public.id
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

resource "aws_instance" "this" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.this.id]
  key_name        = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
			  #!/bin/bash
			  sudo apt-get update
			  sudo apt-get install -y nginx
			  sudo systemctl start nginx
			  sudo systemctl enable nginx
			  echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
        echo "Change made by Terraform" | sudo tee -a /var/www/html/index.html"
			  EOF

  lifecycle {
	create_before_destroy = true
  }

  tags = {
    Name = "public-instance"
  }

}

resource "aws_sns_topic" "this" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = var.sns_protocol
  endpoint  = var.email
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name                = var.alarm_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_actions             = [aws_sns_topic.this.arn]
  dimensions = {
    InstanceId = aws_instance.this.id
  }
}
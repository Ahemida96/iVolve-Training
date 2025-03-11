data "aws_vpc" "main" {
  state = "available"
  tags = {
    Name = "main"
  }

  filter {
    name   = "main"
    values = ["main-vpc"]
  }
}

module "network" {
  source               = "./modules/network_module"

  vpc_id               = data.aws_vpc.main.id
  public_subnets       = ["10.0.1.0/24", "10.0.3.0/24"]
  public_subnet_names  = ["public-subnet-1", "public-subnet-2"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "server-a" {
  source = "./modules/server_module"

  vpc_id             = data.aws_vpc.main.id
  instance_type      = "t2.micro"
  security_group_name = "server-sg"
  key_name = "terraform-key"
  subnet_id          = module.network.public_subnets[0]
  is-public          = true
}


module "server-b" {
  source = "./modules/server_module"

  vpc_id             = data.aws_vpc.main.id
  instance_type      = "t2.micro"
  security_group_name = "server-sg"
  key_name = "terraform-key"
  subnet_id          = module.network.public_subnets[1]
  is-public          = true
}

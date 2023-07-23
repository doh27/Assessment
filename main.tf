module "vpc" {
  source = "./modules/aws_vpc"

  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "noela-assessment"
  enable_dns_hostnames = true
  vpc_tags             = {}

  # Subnets
  public_subnet_cidrs = ["10.0.0.0/28"]
  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnet_tags = {
    Type = "Public"
  }
  private_subnet_cidrs = ["10.0.0.16/28", "10.0.0.32/28"]
  private_subnet_tags = {
    Type = "Private"
  }
  connectivity_type  = "public"
  is_nat_gw_required = false
}

module "public_sg" {
  source = "./modules/aws_sg"

  sg_name = "public-sg"
  sg_desc = "Security Group for EC2 instance in Public subnet"
  vpc_id  = module.vpc.vpc_id
  ingress_rules = {
    "ssh" = {
      description = "Allow All SSH connection"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress_rules = {
    "ssh" = {
      description = "Allow All connections"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "public_ec2" {
  source = "./modules/aws_ec2"

  ami           = "ami-05548f9cecf47b442"
  instance_type = "t2.micro"
  volume_size   = 50
  volume_type   = "gp2"

  security_group_ids = [module.public_sg.sg_id]
  subnet_id          = module.vpc.public_subnet_ids[0]
  key_pair_name      = "assessment"
  ec2_tags = {
    Name = "Public 1a"
  }
}

module "private_sg" {
  source = "./modules/aws_sg"

  sg_name = "private-sg"
  sg_desc = "Security Group for EC2 instance in Private subnet"
  vpc_id  = module.vpc.vpc_id
  ingress_rules = {
    "ssh" = {
      description = "Allow SSH connection from Public subnet only"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = formatlist("%s/32", module.public_ec2.ec2_attributes["public_ip"])
    },
    "ssh_from_public_subnet" = {
      description = "Allow SSH connection with Public subnets"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/28"]
    },
    "same_sg" = {
      description = "Allow SSH connection with Private subnets"
      from_port   = 22
      to_port     = 22
      protocol    = "-1"
      cidr_blocks = ["10.0.0.16/28", "10.0.0.32/28"]
    }
  }
  egress_rules = {
    "ssh" = {
      description = "Allow All connections"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "private_ec2" {
  source = "./modules/aws_ec2"

  ami           = "ami-05548f9cecf47b442"
  instance_type = "t2.micro"
  volume_size   = 50
  volume_type   = "gp2"

  security_group_ids = [module.private_sg.sg_id]
  subnet_id          = module.vpc.private_subnet_ids[0]
  key_pair_name      = "assessment"
  ec2_tags = {
    Name = "Private 1a"
  }
}

module "private_ec2_1b" {
  source = "./modules/aws_ec2"

  ami           = "ami-05548f9cecf47b442"
  instance_type = "t2.micro"
  volume_size   = 50
  volume_type   = "gp2"

  security_group_ids = [module.private_sg.sg_id]
  subnet_id          = module.vpc.private_subnet_ids[1]
  key_pair_name      = "assessment"
  ec2_tags = {
    Name = "Private 1b"
  }
}
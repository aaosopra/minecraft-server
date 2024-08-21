##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.region
}


##################################################################################
# Data
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# MODULES
##################################################################################

module "ubuntu_22_04_latest" {
  source = "github.com/andreswebs/terraform-aws-ami-ubuntu"
}

##################################################################################
# RESOURCES
##################################################################################
locals {
  common_tags = {
    Environment = var.environment
  }
}

module "main" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.prefix
  cidr = var.cidr_block

  azs                     = slice(data.aws_availability_zones.available.names, 0, 1)
  public_subnets          = [var.public_subnet]
  enable_dns_hostnames    = true
  public_subnet_suffix    = ""
  public_route_table_tags = { Name = "${var.prefix}-public" }
  map_public_ip_on_launch = true

  enable_nat_gateway = false

  tags = local.common_tags
}

resource "aws_security_group" "webapp_ssh_inbound_sg" {
  name        = "${var.prefix}-ssh-inbound"
  description = "Allow SSH from certain ranges"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ip_range]
  }

  vpc_id = module.main.vpc_id

  tags = local.common_tags
}

resource "aws_security_group" "app_inbound_sg" {
  name        = "${var.prefix}-inbound"
  description = "Allow inbound to minecraft"

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = [var.ip_range]
  }

  vpc_id = module.main.vpc_id

  tags = local.common_tags
}

# INSTANCES #
resource "aws_instance" "app-instance" {
  ami                    = nonsensitive(module.ubuntu_22_04_latest.ami_id)
  instance_type          = "c5.xlarge"
  subnet_id              = module.main.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.webapp_ssh_inbound_sg.id, aws_security_group.app_inbound_sg.id]
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  key_name = module.ssh_keys.key_pair_name
  # Provisioner Stuff
  connection {
    type        = "ssh"
    user        = "ubuntu"
    port        = "22"
    host        = self.public_ip
    private_key = module.ssh_keys.private_key_openssh
  }

  user_data = templatefile("./templates/userdata.sh", {
    playbook_url = var.playbook_url
  })

}

resource "local_file" "ssh_config" {
  content = templatefile("./templates/ssh_config", {
    server_public_ip = aws_instance.app-instance.public_ip
  })
  filename        = "${var.home_path}/.ssh/config"
  file_permission = 0400
}
# AWS infrastructure resources

# VPC 
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-my-vpc"
  }
}

# Subnet
resource "aws_subnet" "my_subnetA" {
  vpc_id = aws_vpc.my_vpc.id

  cidr_block        = "10.0.0.0/24"
  availability_zone = var.az_a

  tags = {
    Name = "${var.prefix}-my-subnetA"
  }
}
# No IGW 
resource "aws_subnet" "my_private_subnetB" {
  vpc_id = aws_vpc.my_vpc.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az_b

  tags = {
    Name = "${var.prefix}-my-private_subnetB"
  }
}


#Route Table
resource "aws_route_table" "rancher_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name = "${var.prefix}-my-route-table"
  }
}

# IGW
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.prefix}-gateway"
  }
}


# Route Table Associate
resource "aws_route_table_association" "rancher_route_table_association" {
  subnet_id      = aws_subnet.my_subnetA.id
  route_table_id = aws_route_table.rancher_route_table.id
}

# Security group to allow all traffic
resource "aws_security_group" "my_sg_allowall" {
  name        = "${var.prefix}-allowall"
  description = "test- allow all traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Creator = "test-quickstart"
  }
}

##### 
# 🔑 Create Key Pair 
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "key_pair" {
  key_name = var.aws-keypair
  public_key      = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${path.root}/generated-key.pem"
  content  = tls_private_key.ssh_key.private_key_openssh

  provisioner "local-exec" {
    command = "chmod 400 ${path.root}/generated-key.pem"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-dev-s3"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
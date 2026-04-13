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
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.prefix}-my-public-subnetA"
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
#######################################
# Security group to allow all traffic
#######################################

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

##################
# IAM Role for SSM
# #################
resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}
###################
## iam role attachment
###################
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
#################
## profile
#################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ssm-profile2"
  role = aws_iam_role.ec2_ssm_role.name
}

###############################
##Create ec2 on public subnet
###############################
resource "aws_instance" "ec2_node" {

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  vpc_security_group_ids      = [aws_security_group.my_sg_allowall.id]
  subnet_id                   = aws_subnet.my_subnetA.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

###############################
##Create ec2 on private subnet
###############################
resource "aws_instance" "ec2_private" {
 
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  vpc_security_group_ids      = [aws_security_group.my_sg_allowall.id]
  subnet_id                   = aws_subnet.my_private_subnetB.id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}
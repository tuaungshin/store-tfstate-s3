
###Security group SSM
resource "aws_security_group" "ssm_endpoint_sg" {
  name   = "ssm-endpoint-sg"
  vpc_id = aws_vpc.my_vpc.id


## inbound traffice to instance..from port 443, protocol TCP
  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # better: restrict to VPC CIDR
  }

## from instance outbound rule .to anywhere.any port.any protocol##
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


##1-SSM Endpoint
##
resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.my_subnetA.id
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}

###2-EC2 Messages Endpoint

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.my_subnetA.id
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}

###3-SSM Messages Endpoint

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids         = aws_subnet.my_subnetA.id
  security_group_ids = [aws_security_group.ssm_endpoint_sg.id]

  private_dns_enabled = true
}
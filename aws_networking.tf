# Creating the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr # value defined in terraform.tfvars
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = var.vpc_name
    }
  )
}

# Creating the Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "Main Internet Gateway"
    }
  )
}

# Creating the Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "Public Subnet ${count.index + 1}"
    }
  )
}

# Creating the Private Subnets
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "Private Subnet ${count.index + 1}"
    }
  )
}

# Creating the NAT Gateways with Elastic IPs
resource "aws_eip" "nat_eip" {
  count  = length(var.availability_zones)
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "NAT EIP ${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(aws_subnet.public_subnet)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = merge(
    var.common_tags,
    {
      Name = "NAT Gateway ${count.index + 1}"
    }
  )
}

# Creating the Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Public Route Table"
    }
  )
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Creating the Route Table for Private Subnet
resource "aws_route_table" "private_route_table" {
  count  = length(aws_subnet.private_subnet)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "Private Route Table ${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

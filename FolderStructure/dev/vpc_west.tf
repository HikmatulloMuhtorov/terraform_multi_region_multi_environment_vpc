resource "aws_vpc" "main_west" {
  provider = aws.alt_region
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = format("%s-vpc",var.env)
  }
}

resource "aws_internet_gateway" "west_igw" {
  vpc_id = aws_vpc.main_west.id
  provider = aws.alt_region
  tags = {
    Name = format("%s-igw",var.env)
  }
}

resource "aws_route_table" "west_public_route" {
  vpc_id = aws_vpc.main_west.id
  provider = aws.alt_region
  route {
    gateway_id = aws_internet_gateway.west_igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = format("%s-pub-route",var.env)
  }
}

resource "aws_subnet" "west_pub_sub_1" {
  count = length(var.pub_cidr_blocks)
  vpc_id     = aws_vpc.main_west.id
  cidr_block = element(var.pub_cidr_blocks, count.index)
  provider = aws.alt_region
  tags = {
    Name = "${var.env}-pubsub-${count.index}"
  }
}


resource "aws_main_route_table_association" "a_west" {
  route_table_id = aws_route_table.west_public_route.id
  vpc_id = aws_vpc.main_west.id
  provider = aws.alt_region
}

resource "aws_route_table_association" "a_west" {
  count = length(var.west_route_table_associations)
  subnet_id      = element(var.west_route_table_associations,count.index)
  route_table_id = aws_route_table.public_route.id
  provider = aws.alt_region
}

resource "aws_eip" "west_nat_gateway_eip" {
  vpc      = true
  provider = aws.alt_region
}

resource "aws_nat_gateway" "west_nat_gateway" {
  allocation_id = aws_eip.west_nat_gateway_eip.id
  subnet_id     = aws_subnet.pub_sub_1[0].id
  provider = aws.alt_region
  tags = {
    Name = format("%s-nat-gateway",var.env)
  }
}

resource "aws_route_table" "west_private_route" {
  vpc_id = aws_vpc.main_west.id
  provider = aws.alt_region
  route {
    gateway_id = aws_nat_gateway.west_nat_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = format("%s-priv-route",var.env)
  }
}

resource "aws_subnet" "west_priv_sub_1" {
  count = length(var.priv_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.priv_cidr_blocks, count.index)
  provider = aws.alt_region
  tags = {
    Name = "${var.env}-privsub-${count.index}"
  }
}

resource "aws_route_table_association" "b_west" {
  count = length(var.west_aws_subnet_priv_subs)
  subnet_id      = element(var.west_aws_subnet_priv_subs, count.index)
  route_table_id = aws_route_table.private_route.id
  provider = aws.alt_region
}
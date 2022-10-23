resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = format("%s-vpc",var.env)
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-igw",var.env)
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = format("%s-pub-route",var.env)
  }
}

resource "aws_subnet" "pub_sub_1" {
  count = length(var.pub_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.pub_cidr_blocks, count.index)

  tags = {
    Name = "${var.env}-pubsub-${count.index}"
  }
}


resource "aws_main_route_table_association" "a" {
  route_table_id = aws_route_table.public_route.id
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "a" {
  count = length(var.route_table_associations)
  subnet_id      = element(var.route_table_associations,count.index)
  route_table_id = aws_route_table.public_route.id
}

resource "aws_eip" "nat_gateway_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.pub_sub_1[0].id

  tags = {
    Name = format("%s-nat-gateway",var.env)
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_nat_gateway.nat_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = format("%s-priv-route",var.env)
  }
}

resource "aws_subnet" "priv_sub_1" {
  count = length(var.priv_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.priv_cidr_blocks, count.index)

  tags = {
    Name = "${var.env}-privsub-${count.index}"
  }
}

resource "aws_route_table_association" "b" {
  count = 3
  subnet_id      = element(var.aws_subnet_priv_subs, count.index)
  route_table_id = aws_route_table.private_route.id
}


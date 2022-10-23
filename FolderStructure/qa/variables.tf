variable "env" {
    type = string
    description = "This is a variable for Environment"
    default = "qa"
}

variable "instance_type" {
    type = string
    description = "This is a variable for instance type"
    default = "t2.micro"
}

variable "pub_cidr_blocks" {
  type = list(string)
  description = "This is a list of pub cidr blocks"
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "route_table_associations" {
    type = list(string)
    description = "This is a list of route tables"
    default = ["aws_subnet.pub_sub_1.id", "aws_subnet.pub_sub_1.id","aws_subnet.pub_sub_1.id]"]
}

variable "priv_cidr_blocks" {
  type = list(string)
  description = "this is a list of priv cidr blocks"
  default = [ "10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24" ]
}

variable "aws_subnet_priv_subs" {
  type = list(string)
  description = "This is a list of private subnets"
  default = [ "aws_subnet.priv_sub.id", "aws_subnet.priv_sub.id", "aws_subnet.priv_sub.id"]
}

variable "west_aws_subnet_priv_subs" {
  type = list(string)
  description = "This is a list of private subnets"
  default = [ "aws_subnet.west_priv_sub.id", "aws_subnet.west_priv_sub.id", "aws_subnet.west_priv_sub.id"]
}

variable "west_route_table_associations" {
    type = list(string)
    description = "This is a list of route tables"
    default = ["aws_subnet.west_pub_sub_1.id", "aws_subnet.west_pub_sub_1.id","aws_subnet.west_pub_sub_1.id]"]
}
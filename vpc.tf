//This specifies the vpc environment
resource "aws_vpc" "practvpc_002" {
    cidr_block = "10.2.0.0/16"
}
//This deploys the public subnet a 
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = "${aws_vpc.practvpc_002.id}"
  cidr_block = "10.2.1.0/24"
  availability_zone = "us-east-1a"
}
//This deploys the public subnet b
resource "aws_subnet" "public_subnet_b" {
  vpc_id     = "${aws_vpc.practvpc_002.id}"
  cidr_block = "10.2.2.0/24"
  availability_zone = "us-east-1b"
}
//This deploys  the private subnet a
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = "${aws_vpc.practvpc_002.id}"
  cidr_block = "10.2.3.0/24"
  availability_zone = "us-east-1a"
}
//This deploys the private subnet b
resource "aws_subnet" "private_subnet_b" {
  vpc_id     = "${aws_vpc.practvpc_002.id}"
  cidr_block = "10.2.4.0/24"
  availability_zone = "us-east-1b"
}
//This creates the internet gateway for the VPC
resource "aws_internet_gateway" "my_ig" {
  vpc_id = "${aws_vpc.practvpc_002.id}"
}
//This creates the route table for public subnet a
resource "aws_route_table" "public_subnet_a_route" {
  vpc_id = "${aws_vpc.practvpc_002.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_ig.id}"
  }
}
//This creates the route table for public subnet b
resource "aws_route_table" "public_subnet_b_route" {
  vpc_id = "${aws_vpc.practvpc_002.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my_ig.id}"
  }
}
//This creates the route table association for public subnet a
resource "aws_route_table_association" "public_subnet_a_asso" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_subnet_a_route.id
}
//This creates  the route table association for public subnet b
resource "aws_route_table_association" "public_subnet_b_asso" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_subnet_b_route.id
}
//This creates the nat gateway for private subnet a
resource "aws_nat_gateway" "private_subnet_a_nat" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = "${aws_subnet.public_subnet_a.id}"
  depends_on    = [aws_internet_gateway.my_ig]
}
//This creates the nat gateway for private subnet b
resource "aws_nat_gateway" "private_subnet_b_nat" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = "${aws_subnet.public_subnet_b.id}"
  depends_on    = [aws_internet_gateway.my_ig]
}
//This creates the route table for private subnet a
resource "aws_route_table" "private-subnet_a_route" {
  vpc_id = "${aws_vpc.practvpc_002.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.private_subnet_a_nat.id}"
  }
}
//This creates the route table for private subnet b
resource "aws_route_table" "private-subnet_b_route" {
  vpc_id = "${aws_vpc.practvpc_002.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.private_subnet_b_nat.id}"
  }
}
//This creates the route table association for private subnet a
resource "aws_route_table_association" "private_subnet_a_asso" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private-subnet_a_route.id
}
//This creates the route table association for private subnet b
resource "aws_route_table_association" "private_subnet_b_asso" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private-subnet_b_route.id
}
//assigning an EIP for NAT gateway in AZ a
resource "aws_eip" "nat_eip_a" {
  vpc        =  true
  depends_on = [aws_internet_gateway.my_ig]
}
//assigning an EIP for NAT gateway in  AZ b
resource "aws_eip" "nat_eip_b" {
  vpc = true
  depends_on = [aws_internet_gateway.my_ig]
}
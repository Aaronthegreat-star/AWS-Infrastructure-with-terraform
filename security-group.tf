resource "aws_security_group" "private_sg" {
  name = "my-sg"
  description = "Security group for the subnets"
  vpc_id = aws_vpc.practvpc_002.id
  //defining ingress and egress rules
  //allowing http and https request
  ingress{
    from_port = 80
    to_port =  80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port = 443
    to_port =  443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "sg_for_my_lb" {
  name = "my-lb-sg"
  description = "Security group for the subnets"
  vpc_id = aws_vpc.practvpc_002.id
  //defining ingress and egress rules
  //allowing http traffic for my lb
  ingress{
    from_port = 80
    to_port =  80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress{
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

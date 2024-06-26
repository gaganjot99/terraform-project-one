resource "aws_security_group" "sg_one" {
  name        = "allow_ssh"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc_one.id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg_one.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
   tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg_one.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "sg_two" {
  name        = "allow_icmp"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc_two.id

  tags = {
    Name = "allow_icmp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp_ipv4" {
  security_group_id = aws_security_group.sg_two.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port = -1
  to_port = -1
  ip_protocol       = "icmp"
   tags = {
    Name = "allow_icmp"
  }
}
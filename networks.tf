resource "aws_vpc" "vpc_one" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "VPC1"
  }
}

resource "aws_vpc" "vpc_two" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC2"
  }
}

resource "aws_subnet" "subnet_one" {
    vpc_id = aws_vpc.vpc_one.id
    cidr_block = "172.31.0.0/24"
    tags = {
        Name = "public_subnet1"
    }

}

resource "aws_subnet" "subnet_two" {
    vpc_id = aws_vpc.vpc_two.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "private_subnet1"
    }
}

resource "aws_ec2_transit_gateway" "tg_one" {
  description = "transit gateway to connect the vpcs"
  tags = {
    Name = "Transit_gateway_one"
  }
}

resource "aws_internet_gateway" "ig_one" {
    vpc_id = aws_vpc.vpc_one.id
  tags = {
    Name = "internet_gateway_one"
  }
}

resource "aws_route_table" "route_table_one" {
  vpc_id = "${aws_vpc.vpc_one.id}"

  route {
    cidr_block = "10.0.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.tg_one.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig_one.id}"
  }

  tags = {
    Name = "Subnet_table_one"
  }
}

resource "aws_route_table" "route_table_two" {
  vpc_id = "${aws_vpc.vpc_two.id}"

  route {
    cidr_block = "172.31.0.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tg_one.id
  }

  tags = {
    Name = "Subnet_table_two"
  }
}

resource "aws_route_table_association" "a_one" {
  subnet_id      = aws_subnet.subnet_one.id
  route_table_id = aws_route_table.route_table_one.id
}

resource "aws_route_table_association" "a_two" {
  subnet_id      = aws_subnet.subnet_two.id
  route_table_id = aws_route_table.route_table_two.id
}

resource "aws_ec2_transit_gateway_route_table" "tg_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tg_one.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tg_rta1" {
  subnet_ids         = [aws_subnet.subnet_one.id]
  transit_gateway_id = aws_ec2_transit_gateway.tg_one.id
  vpc_id             = aws_vpc.vpc_one.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tg_rta2" {
  subnet_ids         = [aws_subnet.subnet_two.id]
  transit_gateway_id = aws_ec2_transit_gateway.tg_one.id
  vpc_id             = aws_vpc.vpc_two.id
}

resource "aws_ec2_transit_gateway_route" "tg_route_one" {
  destination_cidr_block         = "172.31.0.0/24"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg_rta1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tg_one.association_default_route_table_id
}

resource "aws_ec2_transit_gateway_route" "tg_route_two" {
  destination_cidr_block         = "10.0.0.0/24"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg_rta2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.tg_one.association_default_route_table_id
}



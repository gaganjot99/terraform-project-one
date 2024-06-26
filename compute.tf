resource "aws_key_pair" "key_one" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4iMsmKYeFDoKKTmBboVpVt8KEEiQ1aRNVs5FHu2TjeF04nmwwxlC5zge+LfBf8Khu/OCs1LXHTIo6GJ2an2TtUfGDPZmDuGrBRmurEHRpCzLS/YLAifAOs/N2GmFgzwVq1OhvP5wnRDMcNUjcVS80lunN6UZDFYlBf11BhGIiaxSagAgNAHsL82TeFqXBFd8RYc6OIMQWGzZHKR8eKBNvvlME0w31hsVZ4k8SJtiR7Y5tdI1SonAPH5+JsQiOSqpi7g59kvLI2pYbTuKx78uckrMar4uYVWv/6gyGgc4IXNK8ext5A1mCCzWRLP91vlI9hAb1+rzrd7G/zGu/VjBhaqp1nrsaPclAX42I/nxfR1tvznZLMNuRi1X+G1ZcozQaVN6nTaOMudNzqoSmIzZ0DsdMW8hLPYRVXQctH5HC661TyGbDNs8wYsfBvWpm3gOEPW/mHag7qv1wYKWkdVcISpVoxmF0/Ma9dY3Eh5DR5jGQnxBK41Y/VgZS2MoePPc= ec2-user@ip-172-31-23-230.ec2.internal"
  }

  resource "aws_instance" "server_one" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_one.id
  key_name = "deployer-key"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg_one.id]

  tags = {
    Name = "Linux server one"
  }
}

  resource "aws_instance" "server_two" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_two.id
  vpc_security_group_ids = [aws_security_group.sg_two.id]
  tags = {
    Name = "Linux server two"
  }
}

output "public_ip_address" {
    value = aws_instance.server_one.public_ip
}
output "private_ip_address" {
    value = aws_instance.server_two.private_ip
}
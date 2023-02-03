resource "aws_vpc" "nas_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "nas_public_subnet" {
  vpc_id                  = aws_vpc.nas_vpc.id
  cidr_block              = "10.123.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "nas_internet_gateway" {
  vpc_id = aws_vpc.nas_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "nasa_public_rt" {
  vpc_id = aws_vpc.nas_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.nasa_public_rt.id
  destination_cidr_block = "0.0.0.0/0" #sve ip adrese ce ici na internet gateway, koji definisemo dole
  gateway_id             = aws_internet_gateway.nas_internet_gateway.id
}

resource "aws_route_table_association" "nas_public_assoc" {
  route_table_id = aws_route_table.nasa_public_rt.id
  subnet_id      = aws_subnet.nas_public_subnet.id
}

resource "aws_security_group" "nas_sg" {
  name        = "dev-sg"
  description = "dev security group"
  vpc_id      = aws_vpc.nas_vpc.id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["188.120.99.252/32","0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "nas_auth" { #key pair se koristi za login access na ec2 instancu
  key_name   = "nas_key"
  public_key = file("~/.ssh/naskey.pub")
}

resource "aws_instance" "dev_node" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.nas_auth.id
  vpc_security_group_ids = [aws_security_group.nas_sg.id] #dodajemo sg instanci
  subnet_id              = aws_subnet.nas_public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10 #default je 8
  }

  tags = {
    name = "dev-node"
  }
}

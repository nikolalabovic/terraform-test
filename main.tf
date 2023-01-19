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
  route_table_id = aws_route_table.nasa_public_rt.id
  destination_cidr_block = "0.0.0.0/0" #sve ip adrese ce ici na internet gateway, koji definisemo dole
  gateway_id = aws_internet_gateway.nas_internet_gateway.id
}

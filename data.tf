#AMI(Amazon Machine Image) je image za kreiranje EC2, sadrzi sve potrebne info za kreiranje ec2 instance
data "aws_ami" "server_ami"{
  most_recent = true
  owners = ["099720109477"]

  filter { #creating a filter to provide the right AMI
    name   = "name" #filtrira samo filter name
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
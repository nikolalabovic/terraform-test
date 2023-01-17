terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "europe-central-1"
}

## Create a VPC
#resource "aws_vpc" "example" {
#  cidr_block = ""
#}
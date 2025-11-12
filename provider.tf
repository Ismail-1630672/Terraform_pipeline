terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.20.0"
    }
  }

  required_version = "1.13.4"
}

provider "aws" {
  region = "eu-west-2"
}
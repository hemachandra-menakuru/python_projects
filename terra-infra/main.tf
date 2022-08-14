
terraform {
  backend "s3" {
    bucket               = "teraaform-state"
    key                  = "terraform.tfstate"
    region               = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bkt-dply-terraform"
  tags = {
    Name = "Created and deployed this bucket through terraform"
  }
}

resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.test_bucket.id
  key = "test2.txt"
  source = "/aws/s3/test2.txt"
}
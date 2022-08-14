
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

locals {
  test = abspath(path.root)
  filename = "${path.root}/example"
}
output "test" { value = "${local.test}" }

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bkt-dply-terraform"
  tags = {
    Name = "Created and deployed this bucket through terraform"
  }
}

resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.test_bucket.id
  key = "test2.txt"
  source = "/home/runner/work/python_projects/python_projects/aws/s3/test2.txt"
}
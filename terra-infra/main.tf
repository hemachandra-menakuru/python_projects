
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
  acl    = "private"

  tags = {
    Name = "Created and deployed this bucket through terraform"
  }
}

resource "aws_s3_bucket_object" "object1" {
  for_each = fileset("aws/s3", "*")
  bucket = s3://hem-landing/inbound
  key = each.value
  source = "aws/s3/${each.value}"
  etag = filemd5("aws/s3/${each.value}")
}

}
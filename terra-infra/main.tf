
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
  rootpath = abspath(path.root)
  modulepath = abspath(path.module)
}
output "rootpath" { value = "${local.rootpath}" }
output "modulepath" { value = "${local.modulepath}" }

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bkt-dply-terraform"
  tags = {
    Name = "Created and deployed this bucket through terraform"
  }
}

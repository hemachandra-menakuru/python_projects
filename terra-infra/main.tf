
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

variable "source_files_path" {
  description = "Local files path to uploaded to S3 bucket"
  type        = string
}

locals {
  rootpath = abspath(path.root)
  modulepath = abspath(path.module)
  tfsettingsfile = "../../aws/s3"
  path_cwd         = abspath(path.cwd)
}
output "rootpath" { value = "${local.rootpath}" }
output "modulepath" { value = "${local.modulepath}" }
output "tfsettingsfile" { value = "${local.tfsettingsfile}" }
output "path_cwd" { value = "${local.path_cwd}" }

resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bkt-dply-terraform"
  tags = {
    Name = "Created and deployed this bucket through terraform"
  }
}

resource "aws_s3_object" "objects" {
  for_each = fileset("${var.source_files_path}/", "*.*")
  bucket = aws_s3_bucket.test_bucket.id
  key = "inbound-test/${each.value}"
  source = "${var.source_files_path}/${each.value}"
}
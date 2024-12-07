module "terrafrom_backend_bucket" {
  # https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.2.2"

  bucket = "terraform-backend-tm"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  versioning               = { enabled = true }
  tags                     = var.default_tags
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-tm"
    key    = "tommoulard/infra"
    region = "eu-west-1"
  }
}


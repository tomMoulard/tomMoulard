module "terrafrom_backend_bucket" {
  # https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "terraform-backend"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

module "terrafrom_backend_bucket" {
  # https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.9.0"

  bucket = "backup-tm"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  versioning               = { enabled = true }
  tags                     = var.default_tags
}

locals {
  # Collect all files with their paths relative to the base directories
  files = flatten([
    for dir in var.folders : [
      for file in fileset(dir, "**") : {
        absolute_path = "${dir}/${file}"
      }
    ]
  ])
}

resource "aws_s3_object" "upload" {
  # https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/resources/s3_object
  bucket = module.terrafrom_backend_bucket.s3_bucket_id

  for_each = { for file in local.files : file.absolute_path => file }
  key      = "${var.hostname}${each.value.absolute_path}"
  source   = each.value.absolute_path

  storage_class = "DEEP_ARCHIVE"
  etag          = filemd5(each.value.absolute_path)
  tags          = var.default_tags
}

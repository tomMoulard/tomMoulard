module "terrafrom_backend_bucket" {
  # https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.9.0"

  providers = {
    aws = aws.tommoulard-s3
  }

  bucket = "backup-tm"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  versioning               = { enabled = true }
  tags                     = var.default_tags
}

locals {
  object_tagging_json = jsonencode({
    TagSet = [
      for key, value in var.default_tags : {
        Key   = key
        Value = value
      }
    ]
  })
}



resource "null_resource" "sync" {
  for_each = var.folders

  triggers = {
    destination_bucket = module.terrafrom_backend_bucket.s3_bucket_id
    tags_hash          = sha256(local.object_tagging_json)
    date               = timestamp()
  }

  depends_on = [module.terrafrom_backend_bucket]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    environment = {
      AWS_PROFILE        = "tommoulard-s3"
      AWS_DEFAULT_REGION = "us-east-2"
      SOURCE_FOLDER      = each.key
      BUCKET             = module.terrafrom_backend_bucket.s3_bucket_id
      DESTINATION_URI    = "s3://${module.terrafrom_backend_bucket.s3_bucket_id}/${var.hostname}${each.value}/"
    }
    command = <<-EOT
      set -euo pipefail

      if ! command -v aws >/dev/null 2>&1; then
        echo "aws CLI is required but was not found in PATH." >&2
        exit 1
      fi

      if [ ! -d "$${SOURCE_FOLDER}" ]; then
        echo "Backup source directory $${SOURCE_FOLDER} does not exist." >&2
        exit 1
      fi

      aws s3 sync \
        --storage-class DEEP_ARCHIVE \
        --exact-timestamps \
        --only-show-errors \
        "$${SOURCE_FOLDER}" \
        "$${DESTINATION_URI}"
    EOT
  }
}

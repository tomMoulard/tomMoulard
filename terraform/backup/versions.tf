terraform {
  required_version = ">= 1.9.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # https://github.com/hashicorp/terraform-provider-aws/releases/tag/v5.80.0
      version = ">= 5.80.0"
    }
  }
}

variable "default_tags" {
  default = {
    Owner     = "tommoulard"
    source    = "git@github.com:tomMoulard/tomMoulard.git"
    type      = "backup"
    terraform = "true"
  }
  description = "Default Tags"
  type        = map(string)
}

provider "aws" {
  # aws configure --profile tommoulard-s3
  alias   = "tommoulard-s3"
  region  = "us-east-2"
  profile = "tommoulard-s3"

  default_tags {
    tags = var.default_tags
  }
}

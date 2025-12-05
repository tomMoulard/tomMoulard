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
    "Owner"   = "tommoulard"
    "source"  = "git@github.com:tomMoulard/tomMoulard.git"
    "type"    = "root"
    terraform = "true"
  }
  description = "Default Tags"
  type        = map(string)
}

provider "aws" {
  # aws configure --profile tommoulard-root
  alias   = "tommoulard-root"
  region  = "eu-west-1"
  profile = "tommoulard-root"

  default_tags {
    tags = var.default_tags
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-tm"
    key    = "tommoulard/root"
    region = "eu-west-1"
  }
}

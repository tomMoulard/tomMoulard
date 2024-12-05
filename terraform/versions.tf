terraform {
  required_version = ">= 1.9.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.69.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.46.0"
    }
  }
}

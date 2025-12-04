terraform {
  backend "s3" {
    bucket       = "terraform-backend-tm"
    key          = "tommoulard/backup"
    region       = "eu-west-1"
    use_lockfile = true
  }
}


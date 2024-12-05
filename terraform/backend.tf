terraform {
  backend "s3" {
    bucket = "terraform-backend"
    key    = "tommoulard-perso"
    region = "us-east-2"
    # assume_role = {
    # role_arn = "arn:aws:iam::647702476074:role/TerraformBackend"
    # }
  }
}

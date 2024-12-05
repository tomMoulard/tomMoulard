module "s3_backup" {
  source = "./s3-backup/"
}

module "infra" {
  source = "./infra/"
}

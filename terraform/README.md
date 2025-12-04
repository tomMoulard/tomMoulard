# Terraform

This folder contains the terraform IaC to my own infrastructure.

Here is a list of the features:
 - s3 (glacier deep archive) backups.
 - root account setup
 - infrastructure setup

do not forget to setup corresponding aws account
(e.g., `aws configure --profile tommoulard-s3`).

## backups

To create a backup, you need to fill up a tfvars file like:

```hcl
hostname = "pfs-macos-001"
folders = [
  "/Users/username/Documents",
]
```

and run `make apply-backup`.

rclone sync -P /home/tm/workspace/make-my-server/bitwarden aws-s3-backup-remote://backup-tm/cyprine-001/home/tm/workspace/make-my-server/bitwarden

## root account

Run `make apply-backup`.

It :

 - creates a new IAM user to manage s3 buckets.

## infrastructure

Run `make apply-infra`.

It :

 - creates a s3 bucket to store terraform state.
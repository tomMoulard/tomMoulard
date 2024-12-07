# Terraform

This folder contains the terraform IaC to my own infrastructure.

Here is a list of the features:
 - s3 (glacier deep archive) backups.
 - root account setup
 - infrastructure setup

## backups

To create a backup, you need to fill up a tfvars file like:

```hcl
hostname = "pfs-macos-001"
folders = [
  "/Users/username/Documents",
]
```

and run `make apply-backup`.

## root account

Run `make apply-backup`.

It :

 - creates a new IAM user to manage s3 buckets.

## infrastructure

Run `make apply-infra`.

It :

 - creates a s3 bucket to store terraform state.

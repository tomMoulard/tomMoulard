# Backup Module

## Overview

Terraform configuration that provisions a versioned S3 bucket for archival backups and uploads a selectable set of local folders into the DEEP_ARCHIVE storage class for long-term retention.

## Requirements

- Terraform >= 1.9.4
- Local filesystem access to every directory declared in `var.folders`
- AWS CLI profile `tommoulard-s3` configured with S3 write permissions
- Remote backend bucket `terraform-backend-tm` (created by the infra module) available in `eu-west-1`

## Providers

| Name | Version | Configuration |
|------|---------|---------------|
| aws  | >= 5.80.0 | `alias = "tommoulard-s3"`, `region = us-east-2`, `profile = tommoulard-s3` |

## Inputs

| Name | Type | Required | Description | Default |
|------|------|----------|-------------|---------|
| `folders` | `set(string)` | Yes | Absolute directory paths to recurse and upload into the backup bucket. | `n/a` |
| `hostname` | `string` | Yes | Host identifier prefixed to every object key for segregation. | `n/a` |
| `default_tags` | `map(string)` | No | Common tags attached to the bucket and uploaded objects. | `{ Owner = "tommoulard", source = "git@github.com:tomMoulard/tomMoulard.git", type = "backup", terraform = "true" }` |

## Outputs

| Name | Description |
|------|-------------|
| None | This module does not export outputs. |

## Usage

The module expects all folder paths to exist on the machine running Terraform because `fileset()` walks the local filesystem during plan/apply.

```hcl
module "workstation_backup" {
  source   = "./backup"
  hostname = "pfs-macos-001"
  folders  = [
    "/Users/tom.moulard/Documents",
    "/Users/tom.moulard/Downloads",
    "/Users/tom.moulard/workspace",
  ]
}
```

You can externalize variables in a `tfvars` file similar to `backup/pfs.tfvars` and pass it via `-var-file`.

## Operations / Notes

- Run `make apply-backup-pfs` to execute `terraform init/plan/apply` with `.env.backup` credentials and the sample `pfs.tfvars`.
- Backend locking (`use_lockfile = true`) protects the shared state stored in `terraform-backend-tm` during concurrent runs.
- Uploaded objects use keys in the form `<hostname><absolute_path>`; keep hostnames unique to avoid collisions across machines.
- Every object is stored with the `DEEP_ARCHIVE` storage class—expect 12-48 hour retrieval delays and additional restore costs.
- `filemd5()` detects content changes; deletions must be handled manually (removed files stay in S3 until `terraform state rm` or bucket lifecycle policies purge them).
- Large directory trees can make planning slow because Terraform walks the filesystem; consider splitting folders or pre-filtering with dedicated archive tooling.
- Bucket provisioning leverages `terraform-aws-modules/s3-bucket` v5.9.0 with versioning enabled to maintain full history of uploaded archives.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terrafrom_backend_bucket"></a> [terrafrom\_backend\_bucket](#module\_terrafrom\_backend\_bucket) | terraform-aws-modules/s3-bucket/aws | 5.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.upload](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | <pre>{<br/>  "Owner": "tommoulard",<br/>  "source": "git@github.com:tomMoulard/tomMoulard.git",<br/>  "terraform": "true",<br/>  "type": "backup"<br/>}</pre> | no |
| <a name="input_folders"></a> [folders](#input\_folders) | List of folders to backup | `set(string)` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | hostname of the computer to backup | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
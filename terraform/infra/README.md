# Infrastructure Module

## Overview

Terraform configuration that provisions the shared S3 bucket used as the Terraform remote backend across accounts, applying organization-wide tagging and secure ownership controls.

## Requirements

- Terraform >= 1.9.4
- Temporary local state for initial bootstrap (backend bucket does not exist yet)
- AWS CLI profile `tommoulard-s3` with permissions to manage S3 buckets and policies

## Providers

| Name | Version | Configuration |
|------|---------|---------------|
| aws  | >= 5.80.0 | `alias = "tommoulard-s3"`, `region = us-east-2`, `profile = tommoulard-s3` |

## Inputs

| Name | Type | Required | Description | Default |
|------|------|----------|-------------|---------|
| `default_tags` | `map(string)` | No | Tag set applied to every resource created by the module. | `{ Owner = "tommoulard", source = "git@github.com:tomMoulard/tomMoulard.git", type = "infra", terraform = "true" }` |

## Outputs

| Name | Description |
|------|-------------|
| None | This module does not export outputs. |

## Usage

```hcl
module "terraform_backend" {
  source = "./infra"

  # Optional tag overrides
  default_tags = {
    Owner     = "infra-team"
    source    = "git@github.com:tomMoulard/tomMoulard.git"
    type      = "infra"
    terraform = "true"
  }
}
```

The module wraps `terraform-aws-modules/s3-bucket` (v4.2.2) to configure object ownership, ACL, and versioning for the centralized state bucket.

## Operations / Notes

- Bootstrap using `make apply-infra`, which runs `terraform init/plan/apply` with `.env.infra` credentials and passes `infra.tfvars`.
- On the first run, the backend bucket `terraform-backend-tm` does not exist; run `terraform init -backend=false` (or temporarily comment the backend block) before applying, then re-run `terraform init` to migrate state.
- The bucket enforces `ObjectWriter` ownership and versioning to ensure Terraform state files are immutable and auditable.
- Tagging is centralized through `default_tags`; override per environment when needed to align with cost allocation or compliance tagging policies.
- All resources stay in `us-east-2`, while the remote backend itself resides in `eu-west-1` per the backend block—ensure cross-region access is permitted in your AWS organization.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terrafrom_backend_bucket"></a> [terrafrom\_backend\_bucket](#module\_terrafrom\_backend\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.2.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | <pre>{<br/>  "Owner": "tommoulard",<br/>  "source": "git@github.com:tomMoulard/tomMoulard.git",<br/>  "terraform": "true",<br/>  "type": "infra"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
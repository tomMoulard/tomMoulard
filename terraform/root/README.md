# Root Module

## Overview

Terraform configuration that bootstraps the root AWS account by provisioning a dedicated IAM user with full S3 access and exposing long-term credentials tagged for infrastructure automation.

## Requirements

- Terraform >= 1.9.4
- Pre-existing remote state bucket `terraform-backend-tm` in `eu-west-1`
- AWS CLI profile `tommoulard-root` configured with permissions to manage IAM users

## Providers

| Name | Version | Configuration |
|------|---------|---------------|
| aws  | >= 5.80.0 | `alias = "tommoulard-root"`, `region = us-east-2`, `profile = tommoulard-root` |

## Inputs

| Name | Type | Required | Description | Default |
|------|------|----------|-------------|---------|
| `default_tags` | `map(string)` | No | Common AWS tags applied to every managed resource. | `{ Owner = "tommoulard", source = "git@github.com:tomMoulard/tomMoulard.git", type = "root", terraform = "true" }` |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `s3_access_key` | AWS access key ID for the S3 administration user. | No |
| `s3_secret_key` | Secret access key paired with `s3_access_key`. | Yes (nonsensitive wrapper applied, but treat as secret) |

## Usage

```hcl
module "root_account" {
  source = "./root"

  # Optional: override default tagging
  default_tags = {
    Owner     = "automation"
    source    = "git@github.com:tomMoulard/tomMoulard.git"
    type      = "root"
    terraform = "true"
  }
}
```

Consume the exported credentials securely, for example by writing them to a password manager or secrets vault rather than committing them to version control.

## Operations / Notes

- Initialize and apply via `make apply-root`, which wraps `terraform init/plan/apply` using the `.env.root` file for credentials.
- Ensure the remote backend bucket `terraform-backend-tm` exists before running `terraform init`; this module only consumes it.
- The IAM user is created under `/system/` and its access keys are force-destroyed with the user for clean re-provisioning.
- Treat `s3_secret_key` as sensitive output—store it in a secrets manager (e.g., 1Password, AWS Secrets Manager) immediately after apply and avoid local plaintext copies.
- Re-running `apply` rotates access keys because `force_destroy = true`; plan for downstream updates where credentials are consumed.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.80.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.s3_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.s3_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.s3_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.s3_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_policy_document.s3_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default Tags | `map(string)` | <pre>{<br/>  "Owner": "tommoulard",<br/>  "source": "git@github.com:tomMoulard/tomMoulard.git",<br/>  "terraform": "true",<br/>  "type": "root"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_access_key"></a> [s3\_access\_key](#output\_s3\_access\_key) | Access Key |
| <a name="output_s3_secret_key"></a> [s3\_secret\_key](#output\_s3\_secret\_key) | Secret Key |
<!-- END_TF_DOCS -->
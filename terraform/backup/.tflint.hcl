plugin "aws" {
    enabled = true
    version = "0.33.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
    enabled = true
    version = "0.9.1"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
    preset = "recommended"
}

# https://github.com/terraform-linters/tflint-ruleset-terraform/blob/d6b8c4ce9ab6078c706898b8180beee6771278d4/docs/rules/README.md

rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_unused_required_providers" {
  enabled = false
}

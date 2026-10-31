# Organization-wide settings are managed from the Management account in the
# Control Tower home region, where Identity Center also lives.
# Credentials come from the environment (AWS_PROFILE=aft-root locally, an OIDC role in CI).
provider "aws" {
  region              = "ap-southeast-2"
  allowed_account_ids = ["793239448877"]

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Repo      = "org-governance"
    }
  }
}

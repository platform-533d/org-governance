# Shares the account-vending state bucket (Management account, Sydney) under its own key.
# State holds organization and identity metadata only.
terraform {
  backend "s3" {
    bucket       = "account-vending-tfstate-793239448877"
    key          = "org-governance/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}

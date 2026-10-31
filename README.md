# org-governance

Organization-wide settings for the 533d AWS organization, managed from the
Management account (`793239448877`) in `ap-southeast-2`.

| File | Manages |
|---|---|
| `identity-readonly.tf` | `533d-readonly` user, `ReadOnlyInvestigators` group and `ReadOnlyInvestigation` permission set, assigned to every active account |

State: `s3://account-vending-tfstate-793239448877/org-governance/terraform.tfstate`
(bucket created by `account-vending/bootstrap/create-state-bucket.sh`).

## Usage

```bash
aws sso login --profile aft-root
AWS_PROFILE=aft-root terraform init
AWS_PROFILE=aft-root terraform plan
```

## Read-only user first login

The API cannot send the Identity Center invitation. After the first apply, open
IAM Identity Center → Users → `533d-readonly` and choose **Send email verification link**
or **Reset password**, then set the password and register MFA.
Use a private browser window so the admin session is not reused.

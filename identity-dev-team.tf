# Dev team access: full administrator on the xtr4ct-dev feature-development account
# and nothing else. Membership of the group is the only way in, so adding or removing
# a developer is a change to dev_team_members.

locals {
  dev_account_id = "901666513329" # xtr4ct-dev (Sandbox OU)

  dev_team_members = {
    "krish.uppal" = {
      given_name  = "Krish"
      family_name = "Uppal"
      email       = "krishuppal@fashionsports.in"
    }
  }
}

resource "aws_identitystore_user" "dev_team" {
  for_each = local.dev_team_members

  identity_store_id = local.identity_store_id

  user_name    = each.key
  display_name = "${each.value.given_name} ${each.value.family_name}"

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    value   = each.value.email
    primary = true
  }
}

resource "aws_identitystore_group" "dev_team" {
  identity_store_id = local.identity_store_id
  display_name      = "XtrDevTeam"
  description       = "Administrator access to the xtr4ct-dev feature-development account only."
}

resource "aws_identitystore_group_membership" "dev_team" {
  for_each = local.dev_team_members

  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.dev_team.group_id
  member_id         = aws_identitystore_user.dev_team[each.key].user_id
}

resource "aws_ssoadmin_permission_set" "dev_team_admin" {
  instance_arn     = local.sso_instance_arn
  name             = "DevTeamAdministrator"
  description      = "Full administrator for the dev team (AWS managed AdministratorAccess)."
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "dev_team_admin" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dev_team_admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_ssoadmin_account_assignment" "dev_team" {
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.dev_team_admin.arn

  principal_type = "GROUP"
  principal_id   = aws_identitystore_group.dev_team.group_id

  target_type = "AWS_ACCOUNT"
  target_id   = local.dev_account_id

  # Attach the policy before provisioning the permission set into the account.
  depends_on = [aws_ssoadmin_managed_policy_attachment.dev_team_admin]
}

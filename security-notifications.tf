# Control Tower publishes compliance and drift alerts to
# aws-controltower-AggregateSecurityNotifications in the Audit account, one topic per
# governed region. Without a subscriber the alerts go nowhere.
# Email subscriptions stay "PendingConfirmation" until the link in the AWS email is clicked.

locals {
  audit_account_id         = "275452506691"
  security_alerts_endpoint = "platform@533d.consulting"
}

# Control Tower's guardrails leave this topic open to subscriptions; its execution role is
# the standard way in from the Management account.
provider "aws" {
  alias               = "audit_sydney"
  region              = "ap-southeast-2"
  allowed_account_ids = [local.audit_account_id]

  assume_role {
    role_arn     = "arn:aws:iam::${local.audit_account_id}:role/AWSControlTowerExecution"
    session_name = "org-governance"
  }

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Repo      = "org-governance"
    }
  }
}

provider "aws" {
  alias               = "audit_melbourne"
  region              = "ap-southeast-4"
  allowed_account_ids = [local.audit_account_id]

  assume_role {
    role_arn     = "arn:aws:iam::${local.audit_account_id}:role/AWSControlTowerExecution"
    session_name = "org-governance"
  }

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Repo      = "org-governance"
    }
  }
}

resource "aws_sns_topic_subscription" "security_alerts_sydney" {
  provider  = aws.audit_sydney
  topic_arn = "arn:aws:sns:ap-southeast-2:${local.audit_account_id}:aws-controltower-AggregateSecurityNotifications"
  protocol  = "email"
  endpoint  = local.security_alerts_endpoint
}

resource "aws_sns_topic_subscription" "security_alerts_melbourne" {
  provider  = aws.audit_melbourne
  topic_arn = "arn:aws:sns:ap-southeast-4:${local.audit_account_id}:aws-controltower-AggregateSecurityNotifications"
  protocol  = "email"
  endpoint  = local.security_alerts_endpoint
}

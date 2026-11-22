# Opts every account out of AWS using content from AI services (Comprehend,
# Transcribe, Rekognition and others) to improve those services.
# Requires the AISERVICES_OPT_OUT_POLICY policy type: bootstrap/enable-policy-types.sh.

resource "aws_organizations_policy" "ai_opt_out" {
  name        = "ai-services-opt-out"
  description = "Opts all accounts out of AI services content use."
  type        = "AISERVICES_OPT_OUT_POLICY"

  content = jsonencode({
    services = {
      default = {
        opt_out_policy = { "@@assign" = "optOut" }
      }
    }
  })
}

resource "aws_organizations_policy_attachment" "ai_opt_out_root" {
  policy_id = aws_organizations_policy.ai_opt_out.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}

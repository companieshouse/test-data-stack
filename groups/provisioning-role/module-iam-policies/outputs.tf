# Outputs
output "iam_policies_arns" {
  value = {
    "test-data-generator-stack-terraform-plan"    = aws_iam_policy.iam_policy_plan.arn
    "test-data-generator-stack-terraform-apply"   = aws_iam_policy.iam_policy_apply.arn
    "test-data-generator-stack-terraform-destroy" = aws_iam_policy.iam_policy_destroy.arn
  }
}

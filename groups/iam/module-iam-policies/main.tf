# Create policies
resource "aws_iam_policy" "iam_policy_plan" {
  name        = "test-data-generator-stack-terraform-plan"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.test_data_generator_stack_terraform_plan.json
}

resource "aws_iam_policy" "iam_policy_apply" {
  name        = "test-data-generator-stack-terraform-apply"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.test_data_generator_stack_terraform_apply.json
}

resource "aws_iam_policy" "iam_policy_destroy" {
  name        = "test-data-generator-stack-terraform-destroy"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.test_data_generator_stack_terraform_destroy.json
}

# Outputs
output "iam_policies_arns" {
  value = {
    "test-data-generator-stack-terraform-plan"    = aws_iam_policy.iam_policy_plan.arn
    "test-data-generator-stack-terraform-apply"   = aws_iam_policy.iam_policy_apply.arn
    "test-data-generator-stack-terraform-destroy" = aws_iam_policy.iam_policy_destroy.arn
  }
}

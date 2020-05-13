# Create policies
resource "aws_iam_policy" "iam_policy_plan" {
  name        = "test-data-generator-stack-terraform-plan"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.plan.json
}

resource "aws_iam_policy" "iam_policy_apply" {
  name        = "test-data-generator-stack-terraform-apply"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.apply.json
}

resource "aws_iam_policy" "iam_policy_destroy" {
  name        = "test-data-generator-stack-terraform-destroy"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.destroy.json
}

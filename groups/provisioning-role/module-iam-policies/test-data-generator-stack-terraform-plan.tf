data "aws_iam_policy_document" "plan" {

  statement {
    sid       = "PlanPolicyAllResources"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:GenerateRandom",
      "elasticloadbalancing:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "ssm:GetParameters",
      "ssm:DescribeParameters",
      "ssm:ListTagsForResource",
      "ec2:DescribeSecurityGroups",
      "ecs:DescribeTaskDefinition",
      "kms:CreateCustomKeyStore",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "kms:DescribeCustomKeyStores",
      "kms:ListKeys",
      "kms:DeleteCustomKeyStore",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeListeners",
      "kms:UpdateCustomKeyStore",
      "autoscaling:DescribeAutoScalingGroups",
      "kms:ListAliases",
      "elasticloadbalancing:DescribeTargetGroups",
      "kms:DisconnectCustomKeyStore",
      "kms:CreateKey",
      "ecs:DescribeServices",
      "kms:ConnectCustomKeyStore",
    ]
  }

  statement {
    sid    = "PlanPolicyListedResources"
    effect = "Allow"
    resources = [
      "arn:aws:ecs:eu-west-2:${var.aws_account_id}:cluster/test-data-generator-*-cluster",
      "arn:aws:ssm:eu-west-2:${var.aws_account_id}:parameter/test-data-generator-*/secret-mongo-url",
      "arn:aws:iam::*:instance-profile/*",
      "arn:aws:iam::*:role/*",
      "arn:aws:route53:::hostedzone/Z2KSI4Z5ZN9NT0",
    ]
    actions = [
      "iam:GetRole",
      "iam:GetInstanceProfile",
      "iam:ListAttachedRolePolicies",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "ssm:GetParameter",
      "iam:GetRolePolicy",
      "ecs:DescribeClusters",
    ]
  }
  
}

data "aws_iam_policy_document" "destroy" {

  statement {
    sid       = "DestroyPolicyAllResources"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeImages",
      "ecs:DeregisterTaskDefinition",
    ]
  }

  statement {
    sid    = "DestroyPolicyListedResources"
    effect = "Allow"
    resources = [
      "arn:aws:ssm:eu-west-2:${var.aws_account_id}:parameter/test-data-generator-*/secret-mongo-url",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-*-ecs-instance-role",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-*-ecs-service-role",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-*-ecs-task-execution-role",
      "arn:aws:autoscaling:eu-west-2:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/test-data-generator-*-ecs-asg",
      "arn:aws:autoscaling:eu-west-2:${var.aws_account_id}:launchConfiguration:*:launchConfigurationName/test-data-generator-**",
      "arn:aws:ecs:eu-west-2:${var.aws_account_id}:service/test-data-generator-*-cluster/*-test-data-generator",
      "arn:aws:ecs:eu-west-2:${var.aws_account_id}:cluster/test-data-generator-*-cluster",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:listener/net/test-data-*-lb/*/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:listener/app/test-data-*-lb/*/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:loadbalancer/app/test-data-*-lb/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:loadbalancer/net/test-data-*-lb/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:targetgroup/*-test-data-generator/*",
      "arn:aws:iam::${var.aws_account_id}:instance-profile/test-data-generator-*-ecs-instance-profile",
    ]
    actions = [
      "iam:ListInstanceProfilesForRole",
      "ssm:DeleteParameter",
      "iam:DetachRolePolicy",
      "autoscaling:DeleteLaunchConfiguration",
      "iam:DeleteRolePolicy",
      "iam:DeleteRole",
      "autoscaling:UpdateAutoScalingGroup",
      "ecs:DeleteService",
      "ecs:DeleteCluster",
      "autoscaling:DeleteAutoScalingGroup",
      "elasticloadbalancing:DeleteListener",
      "iam:DeleteInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
    ]
  }

  statement {
    sid    = "DestroyPolicyListedResourcesWithConditions"
    effect = "Allow"
    resources = [
      "arn:aws:ec2:eu-west-2:${var.aws_account_id}:security-group/*"
    ]
    actions = [
      "ec2:DeleteSecurityGroup",
    ]
    condition {
      test     = "StringLikeIfExists"
      variable = "ec2:ResourceTag/Name"
      values = [
        "test-data-generator-*-internal-service-sg"
      ]
    }
  }

}

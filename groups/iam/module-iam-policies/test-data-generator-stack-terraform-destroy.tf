data "aws_iam_policy_document" "test_data_generator_stack_terraform_destroy" {

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
      "arn:aws:ssm:eu-west-2:${var.aws_account_id}:parameter/test-data-generator-devops1/secret-mongo-url",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-devops1-ecs-instance-role",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-devops1-ecs-service-role",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-devops1-ecs-task-execution-role",
      "arn:aws:autoscaling:eu-west-2:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/test-data-generator-devops1-ecs-asg",
      "arn:aws:autoscaling:eu-west-2:${var.aws_account_id}:launchConfiguration:*:launchConfigurationName/test-data-generator-devops1*",
      "arn:aws:ecs:eu-west-2:${var.aws_account_id}:service/test-data-generator-devops1-cluster/devops1-test-data-generator",
      "arn:aws:ecs:eu-west-2:${var.aws_account_id}:cluster/test-data-generator-devops1-cluster",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:listener/net/test-data-devops1-lb/*/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:listener/app/test-data-devops1-lb/*/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:loadbalancer/app/test-data-devops1-lb/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:loadbalancer/net/test-data-devops1-lb/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:targetgroup/devops1-test-data-generator/*",
      "arn:aws:ec2:eu-west-2:${var.aws_account_id}:security-group/*",
      "arn:aws:iam::${var.aws_account_id}:instance-profile/test-data-generator-devops1-ecs-instance-profile",
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
      "ec2:DeleteSecurityGroup",
      "iam:RemoveRoleFromInstanceProfile",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
    ]
  }
  
}

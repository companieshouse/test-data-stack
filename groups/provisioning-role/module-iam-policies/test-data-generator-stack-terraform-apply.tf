data "aws_iam_policy_document" "apply" {

  statement {
    sid       = "ApplyPolicyAllResources"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeImages",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:RevokeSecurityGroupEgress",
      "ecs:CreateCluster",
      "ecs:RegisterTaskDefinition",
    ]
  }

  statement {
    sid    = "ApplyPolicyListedResources"
    effect = "Allow"
    resources = [
      "arn:aws:ecs:eu-west-2:${var.aws_account_id}:service/test-data-generator-*-cluster/*-test-data-generator",
      "arn:aws:ssm:eu-west-2:${var.aws_account_id}:parameter/test-data-generator-*/secret-mongo-url",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-*-ecs-task-execution-role",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-*-ecs-instance-role",
      "arn:aws:iam::${var.aws_account_id}:role/test-data-generator-*-ecs-service-role",
      "arn:aws:iam::${var.aws_account_id}:instance-profile/test-data-generator-*-ecs-instance-profile",
      "arn:aws:route53:::change/*",
      "arn:aws:route53:::hostedzone/Z2KSI4Z5ZN9NT0",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:loadbalancer/app/test-data-*-lb/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:loadbalancer/net/test-data-*-lb/*",
      "arn:aws:elasticloadbalancing:eu-west-2:${var.aws_account_id}:targetgroup/*-test-data-generator/*",
      "arn:aws:autoscaling:eu-west-2:${var.aws_account_id}:autoScalingGroup:*:autoScalingGroupName/test-data-generator-*-ecs-asg",
      "arn:aws:autoscaling:eu-west-2:${var.aws_account_id}:launchConfiguration:*:launchConfigurationName/*",
      "arn:aws:kms:*:*:alias/*",
      "arn:aws:kms:*:*:key/*",
    ]
    actions = [
      "ecs:CreateService",
      "ecs:UpdateService",
      "ssm:PutParameter",
      "ssm:GetParameter",
      "iam:PassRole",
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "route53:GetChange",
      "route53:ChangeResourceRecordSets",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:SetSecurityGroups",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:CreateAutoScalingGroup",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:Decrypt",
      "kms:Encrypt",
    ]
  }
  
}

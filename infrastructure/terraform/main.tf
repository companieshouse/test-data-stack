provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 2.32.0"
}

provider "github" {
  token = "${var.github-ssh-key}"
}

terraform {
  backend "s3" {
  }
}

# Configure the remote state data source to acquire configuration
# created through the code in ch-service-terraform/aws-mm-networks.
data "terraform_remote_state" "networks" {
  backend = "s3"

  config = {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.state_prefix}/${var.deploy_to}/${var.deploy_to}.tfstate"
    region = "${var.aws_region}"
  }
}

# Configure the remote state data source to acquire configuration
# created through the code in the regional-infrastructure stack in this repo.
# aws_profile matches the environment used in regional_infra so statefile path
# references aws_profile (e.g. devlondon) rather than aws_region (e.g. eu-west-2)
data "terraform_remote_state" "regional-infrastructure" {
  backend = "s3"

  config = {
    bucket = "${var.remote_state_bucket}"
    key    = "ecs-stack-pocs/${var.aws_profile}/regional-infrastructure.tfstate"
    region = "${var.aws_region}"
  }
}

locals {
  # stack name is hardcoded here in main.tf for this stack. It should not be overridden per env
  stack_name  = "test-data-generator"
  name_prefix = "${local.stack_name}-${var.environment}"
}

module "ecs-cluster" {
  source = "git::git@github.com:companieshouse/terraform-library-ecs-cluster.git?ref=1.1.0"

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = "${var.environment}"

  vpc_id                     = "${lookup(var.vpc_id, var.aws_region)}"
  ec2_key_pair_name          = "${var.ec2_key_pair_name}"
  ec2_instance_type          = "${var.ec2_instance_type}"
  ec2_image_id               = "${var.ec2_image_id}"
  asg_max_instance_count     = "${var.asg_max_instance_count}"
  asg_min_instance_count     = "${var.asg_min_instance_count}"
  asg_desired_instance_count = "${var.asg_desired_instance_count}"
  application_subnet_ids     = "${data.terraform_remote_state.networks.outputs.application_ids}"
}

module "secrets" {
  source = "./module-secrets"

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = "${var.environment}"
  kms_key_id  = "${data.terraform_remote_state.regional-infrastructure.outputs.poc_ecs_cluster_kms_key_id}"
  secrets     = "${var.secrets}"
}

module "ecs-services" {
  source = "./module-ecs-services"

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = "${var.environment}"

  vpc_id                  = "${lookup(var.vpc_id, var.aws_region)}"
  aws_region              = "${var.aws_region}"
  ssl_certificate_id      = "${var.ssl_certificate_id}"
  zone_id                 = "${var.zone_id}"
  zone_name               = "${var.zone_name}"
  internal_cidrs          = "${var.internal_cidrs}"
  application_ids         = "${data.terraform_remote_state.networks.outputs.application_ids}"
  application_cidrs       = "${data.terraform_remote_state.networks.outputs.application_cidrs}"
  ecs_cluster_id          = "${module.ecs-cluster.ecs_cluster_id}"
  task_execution_role_arn = "${module.ecs-cluster.ecs_task_execution_role_arn}"

  secrets_arn_map = "${module.secrets.secrets_arn_map}"
}

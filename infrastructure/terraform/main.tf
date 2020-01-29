provider "aws" {
  region  = var.aws_region
  version = "~> 2.32.0"
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
    bucket = var.remote_state_bucket
    key    = "${var.state_prefix}/${var.deploy_to}/${var.deploy_to}.tfstate"
    region = var.aws_region
  }
}

# Configure the remote state data source to acquire configuration
# created through the code in the services-stack-configs stack in the
# aws-common-infrastructure-terraform repo.
data "terraform_remote_state" "services-stack-configs" {
  backend = "s3"

  config = {
    bucket = var.aws_bucket # aws-common-infrastructure-terraform repo uses the same remote state bucket
    key    = "aws-common-infrastructure-terraform/common/services-stack-configs.tfstate"
    region = var.aws_region
  }
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.VAULT_USERNAME}"
    parameters = {
      password = var.VAULT_PASSWORD
    }
  }
}

data "vault_generic_secret" "secrets" {
  for_each = toset(var.vault_secrets)
  path = "applications/${var.aws_profile}/${var.environment}/${each.value}"
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
  environment = var.environment

  vpc_id                     = data.terraform_remote_state.networks.outputs.vpc_id
  ec2_key_pair_name          = var.ec2_key_pair_name
  ec2_instance_type          = var.ec2_instance_type
  ec2_image_id               = var.ec2_image_id
  asg_max_instance_count     = var.asg_max_instance_count
  asg_min_instance_count     = var.asg_min_instance_count
  asg_desired_instance_count = var.asg_desired_instance_count
  application_subnet_ids     = data.terraform_remote_state.networks.outputs.application_ids
}

module "secrets" {
  source = "./module-secrets"

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = var.environment
  kms_key_id  = data.terraform_remote_state.services-stack-configs.outputs.services_stack_configs_kms_key_id
  secrets     = data.vault_generic_secret.secrets
}

module "ecs-services" {
  source = "./module-ecs-services"

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = var.environment

  vpc_id                          = data.terraform_remote_state.networks.outputs.vpc_id
  aws_region                      = var.aws_region
  ssl_certificate_id              = var.ssl_certificate_id
  zone_id                         = var.zone_id
  top_level_domain                = var.top_level_domain
  internal_cidrs                  = var.internal_cidrs
  mgmt-eu-west-1_cidrs            = var.mgmt-eu-west-1_cidrs
  application_ids                 = data.terraform_remote_state.networks.outputs.application_ids
  application_cidrs               = data.terraform_remote_state.networks.outputs.application_cidrs
  ecs_cluster_id                  = module.ecs-cluster.ecs_cluster_id
  task_execution_role_arn         = module.ecs-cluster.ecs_task_execution_role_arn
  docker_registry                 = var.docker_registry
  app_version_test_data_generator = var.app_version_test_data_generator
  docker_container_port           = var.docker_container_port

  log_level       = var.log_level
  secrets_arn_map = module.secrets.secrets_arn_map
}

# output "var_secrets" {
#   value = var.secrets
# }
#
# output "vault_secrets" {
#   value = data.vault_generic_secret.secrets
# }

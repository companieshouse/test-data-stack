terraform {

  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.54.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.18.0"
    }
  }

  backend "s3" {}
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}

module "ecs-cluster" {
  source = "git@github.com:companieshouse/terraform-modules//aws/ecs/ecs-cluster?ref=1.0.275"

  aws_profile                = var.aws_profile
  stack_name                 = local.stack_name
  name_prefix                = local.name_prefix
  environment                = var.environment
  vpc_id                     = local.vpc_id
  subnet_ids                 = local.application_ids
  ec2_key_pair_name          = var.ec2_key_pair_name
  ec2_instance_type          = var.ec2_instance_type
  asg_max_instance_count     = var.asg_max_instance_count
  asg_min_instance_count     = var.asg_min_instance_count
  asg_desired_instance_count = var.asg_desired_instance_count
}

module "secrets" {
  source = "./module-secrets"

  stack_name  = local.stack_name
  name_prefix = local.name_prefix
  environment = var.environment
  kms_key_id  = data.terraform_remote_state.services-stack-configs.outputs.services_stack_configs_kms_key_id
  secrets     = data.vault_generic_secret.secrets.data
}

module "ecs-stack" {
  source = "./module-ecs-stack"

  stack_name                = local.stack_name
  name_prefix               = local.name_prefix
  environment               = var.environment
  vpc_id                    = local.vpc_id
  ssl_certificate_id        = var.ssl_certificate_id
  zone_id                   = var.zone_id
  external_top_level_domain = var.external_top_level_domain
  internal_top_level_domain = var.internal_top_level_domain
  subnet_ids                = local.lb_subnet_ids
  web_access_cidrs          = local.lb_access_cidrs
  test_data_lb_internal     = var.test_data_lb_internal
  concourse_access_cidrs    = local.concourse_access_cidrs
}

module "ecs-services" {
  source = "./module-ecs-services"

  name_prefix               = local.name_prefix
  environment               = var.environment
  test-data-lb-arn          = module.ecs-stack.test-data-lb-listener-arn
  test-data-lb-listener-arn = module.ecs-stack.test-data-lb-listener-arn
  vpc_id                    = local.vpc_id
  subnet_ids                = local.application_ids
  web_access_cidrs          = local.app_access_cidrs
  aws_region                = var.aws_region
  ssl_certificate_id        = var.ssl_certificate_id
  external_top_level_domain = var.external_top_level_domain
  internal_top_level_domain = var.internal_top_level_domain
  account_subdomain_prefix  = var.account_subdomain_prefix
  ecs_cluster_id            = module.ecs-cluster.ecs_cluster_id
  task_execution_role_arn   = module.ecs-cluster.ecs_task_execution_role_arn
  docker_registry           = var.docker_registry
  secrets_arn_map           = module.secrets.secrets_arn_map
  log_level                 = var.log_level

  # eric specific configs
  eric_version                   = var.eric_version
  eric_cache_url                 = var.eric_cache_url
  eric_cache_max_connections     = var.eric_cache_max_connections
  eric_cache_max_idle            = var.eric_cache_max_idle
  eric_cache_idle_timeout        = var.eric_cache_idle_timeout
  eric_cache_ttl                 = var.eric_cache_ttl
  eric_flush_interval            = var.eric_flush_interval
  eric_graceful_shutdown_period  = var.eric_graceful_shutdown_period
  eric_default_rate_limit        = var.eric_default_rate_limit
  eric_default_rate_limit_window = var.eric_default_rate_limit_window

  # test-data-generator variables
  tdg_release_version       = var.tdg_release_version
  tdg_application_port      = "10000"

  # chips filing mock variables
  chips_filing_mock_release_version = var.chips_filing_mock_release_version
  chips_filing_mock_desired_count   = var.chips_filing_mock_desired_count
  chs_kafka_api_url                 = var.chs_kafka_api_url
  kafka_broker_address              = var.kafka_broker_address
  kafka_consumer_topic              = var.kafka_consumer_topic
  kafka_consumer_timeout_ms         = var.kafka_consumer_timeout_ms
  kafka_consumer_sleep_ms           = var.kafka_consumer_sleep_ms
}

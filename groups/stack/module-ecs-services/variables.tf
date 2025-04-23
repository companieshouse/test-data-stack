# Environment
variable "environment" {
  type        = string
  description = "The environment name, defined in envrionments vars."
}
variable "aws_region" {
  type        = string
  description = "The AWS region for deployment."
}

# Networking
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for the target group and security group."
}
variable "test-data-lb-arn" {
  type        = string
  description = "The ARN of the load balancer created in the ecs-stack module."
}
variable "test-data-lb-listener-arn" {
  type        = string
  description = "The ARN of the lb listener created in the ecs-stack module."
}
variable "subnet_ids" {
  type        = string
  description = "Subnet IDs of application subnets from aws-mm-networks remote state."
}
variable "web_access_cidrs" {
  type        = list(string)
  description = "Subnet CIDRs for web ingress rules in the security group."
}

# DNS
variable "external_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for external access."
}
variable "internal_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for internal access."
}
variable "account_subdomain_prefix" {
  type = string
}

# ECS Service
variable "name_prefix" {
  type        = string
  description = "The name prefix to be used for stack / environment name spacing."
}
variable "ecs_cluster_id" {
  type        = string
  description = "The ARN of the ECS cluster to deploy the service to."
}

# Docker Container
variable "docker_registry" {
  type        = string
  description = "The FQDN of the Docker registry."
}
variable "task_execution_role_arn" {
  type        = string
  description = "The ARN of the task execution role that the container can assume."
}
variable "log_level" {
  type        = string
  description = "The log level to be set in the environment variables for the container."
}

# Certificates
variable "ssl_certificate_id" {
  type        = string
  description = "The ARN of the certificate for https access through the ALB."
}

# Secrets
variable "secrets_arn_map" {
  type = map(string)
  description = "The ARNs for all secrets"
}

# ------------------------------------------------------------------------------

# Services

# eric
variable "eric_version" {
  type        = string
  description = "The version of the eric service/container to run as a reverse proxy in front of tdg service."
}
variable "eric_cache_url" {
  type = string
}
variable "eric_cache_max_connections" {
  type = string
}
variable "eric_cache_max_idle" {
  type = string
}
variable "eric_cache_idle_timeout" {
  type = string
}
variable "eric_cache_ttl" {
  type = string
}
variable "eric_flush_interval" {
  type = string
}
variable "eric_graceful_shutdown_period" {
  type = string
}
variable "eric_default_rate_limit" {
  type = string
}
variable "eric_default_rate_limit_window" {
  type = string
}

# test-data-generator
variable "tdg_release_version" {
  type        = string
  description = "The release version for the test-data-generator service."
}
variable "tdg_application_port" {
  type        = string
  description = "The port number for the test-data-generator service."
}

# chips-filing-mock
variable "chips_filing_mock_release_version" {
  type        = string
  description = "The release version for chips filing mock."
}
variable "chips_filing_mock_desired_count" {
  type        = number
  description = "The number of instances of chips filing mock to run."
}
variable "chs_kafka_api_url" {
  type        = string
}
variable "kafka_broker_address" {
  type        = string
}
variable "kafka_consumer_topic" {
  type        = string
}
variable "kafka_consumer_timeout_ms" {
  type        = string
}
variable "kafka_consumer_sleep_ms" {
  type        = string
}

# elastic search
variable "elastic_search_deployed" {
  type        = bool
  description = "Whether elastic search is deployed or not."
}

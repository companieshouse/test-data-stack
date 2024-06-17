# Environment
variable "environment" {
  type        = string
  description = "The environment name, defined in envrionments vars."
}
variable "aws_region" {
  default     = "eu-west-2"
  type        = string
  description = "The AWS region for deployment."
}
variable "aws_profile" {
  default     = "development-eu-west-2"
  type        = string
  description = "The AWS profile to use for deployment."
}

# Terraform
variable "aws_bucket" {
  type        = string
  description = "The bucket used to store the current terraform state files"
}
variable "remote_state_bucket" {
  type        = string
  description = "Alternative bucket used to store the remote state files from ch-service-terraform"
}
variable "state_prefix" {
  type        = string
  description = "The bucket prefix used with the remote_state_bucket files."
}
variable "deploy_to" {
  type        = string
  description = "Bucket namespace used with remote_state_bucket and state_prefix."
}

# Docker Container
variable "docker_registry" {
  type        = string
  description = "The FQDN of the Docker registry."
}
variable "log_level" {
  default     = "INFO"
  type        = string
  description = "The log level for services to use: TRACE, DEBUG, INFO or ERROR"
}

# EC2
variable "ec2_key_pair_name" {
  type        = string
  description = "The key pair for SSH access to ec2 instances in the clusters."
}
variable "ec2_instance_type" {
  default     = "t3.medium"
  type        = string
  description = "The instance type for ec2 instances in the clusters."
}

# Auto-scaling Group
variable "asg_max_instance_count" {
  default     = 1
  type        = number
  description = "The maximum allowed number of instances in the autoscaling group for the cluster."
}
variable "asg_min_instance_count" {
  default     = 1
  type        = number
  description = "The minimum allowed number of instances in the autoscaling group for the cluster."
}
variable "asg_desired_instance_count" {
  default     = 1
  type        = number
  description = "The desired number of instances in the autoscaling group for the cluster. Must fall within the min/max instance count range."
}

# Certificates
variable "ssl_certificate_id" {
  type        = string
  description = "The ARN of the certificate for https access through the ALB."
}

# DNS
variable "zone_id" {
  default = "" # default of empty string is used as conditional when creating route53 records i.e. if no zone_id provided then no route53
  type        = string
  description = "The ID of the hosted zone to contain the Route 53 record."
}
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
  description = "The first part of the account/identity service subdomain - either \"account\" or \"identity\""
  default = "account"
}

# Vault
variable "vault_username" {
  type        = string
  description = "The username used by the Vault provider."
}
variable "vault_password" {
  type        = string
  description = "The password used by the Vault provider."
}

# Networking
variable "test_data_lb_internal" {
  type        = bool
  description = "Whether the Test Data ALB should be internal or public facing"
  default     = true
}

# ------------------------------------------------------------------------------
# Services
# ------------------------------------------------------------------------------

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
  default = "10"
}
variable "eric_cache_max_idle" {
  type = string
  default = "3"
}
variable "eric_cache_idle_timeout" {
  type = string
  default = "240"
}
variable "eric_cache_ttl" {
  type = string
  default = "600"
}
variable "eric_flush_interval" {
  type = string
  default = "10"
}
variable "eric_graceful_shutdown_period" {
  type = string
  default = "2"
}
variable "eric_default_rate_limit" {
  type = string
  default = "600"
}
variable "eric_default_rate_limit_window" {
  type = string
  default = "5m"
}

# test-data-generator

variable "tdg_release_version" {
  type        = string
  description = "The release version for the test-data-generator service."
}

# chips-filing-mock
variable "chips_filing_mock_release_version" {
  type        = string
  description = "The release version for chips filing mock."
}
variable "chips_filing_mock_desired_count" {
  type        = number
  description = "The number of instances of chips filing mock to run."
  default      = 1
}
variable "chs_kafka_api_url" {
  default     = ""
  type        = string
}
variable "kafka_broker_address" {
  type        = string
}
variable "kafka_consumer_topic" {
  type        = string
  default     = "filing-received"
}
variable "kafka_consumer_timeout_ms" {
  type        = string
  default     = "100"
}
variable "kafka_consumer_sleep_ms" {
  type        = string
  default     = "10000"
}

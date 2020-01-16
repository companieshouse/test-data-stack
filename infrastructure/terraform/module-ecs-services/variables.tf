variable "stack_name" {}
variable "name_prefix" {}
variable "environment" {}

variable "docker_image" {}

variable "application_ids" {}
variable "application_cidrs" {}
variable "internal_cidrs" {}
variable "mgmt-eu-west-1_cidrs" {}
variable "aws_region" {}
variable "vpc_id" {}

variable "ssl_certificate_id" {}
variable "zone_id" {}
variable "zone_name" {}

variable "ecs_cluster_id" {}

variable "task_execution_role_arn" {}

//---------------- START: Environment Secrets for services ---------------------

variable "secrets_arn_map" {
  type = map(string)
  description = "The ARNs for all secrets"
}

//---------------- END: Environment Secrets for services ---------------------

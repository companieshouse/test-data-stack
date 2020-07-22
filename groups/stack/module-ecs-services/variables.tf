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

# DNS
variable "external_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for external access."
}
variable "internal_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for internal access."
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
variable "release_version" {
  type        = string
  description = "The github release version used here for Docker image tagging."
}
variable "application_port" {
  type        = string
  description = "The port number on the container bound to the assigned host port."
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

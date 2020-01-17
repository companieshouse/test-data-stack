variable "aws_region" {}
variable "aws_profile" {
  default = "development-eu-west-2"
}

variable "aws_bucket" {
  description = "The bucket used to store the terraform state files"
}

variable "remote_state_bucket" {
  description = "The bucket used to store the remote state files"
}

variable "state_prefix" {}
variable "workspace_key_prefix" {}
variable "state_file_name" {}

# These vpcs are configured for development. Preprod and prod are overridden in the vars file.
variable "vpc_cidr" {
  default = {
    eu-west-2 = "10.75.0.0/16" #London
  }
}

# Required for access from existing Concourse instances
variable "mgmt-eu-west-1_cidrs" {
  type    = list(string)
  default = ["10.50.17.0/24","10.50.19.0/24","10.50.21.0/24"]
}

# VPC ID read from terraform remote state.
variable "vpc_id" {
  default     = ""
}

variable "environment" {}
variable "internal_cidrs" {}
variable "deploy_to" {}

variable "docker_registry" {
  default = "169942020521.dkr.ecr.eu-west-2.amazonaws.com"
}
variable "app_version_test_data_generator" {
  #default = "test01"
  default = "latest" # TODO - remove default to force version to be explicitly passed in
}

variable "ec2_key_pair_name" {
  description = "The name for the cluster."
}

variable "ec2_instance_type" {
  description = "The name for the autoscaling group for the cluster."
  default     = "t3.medium"
}

variable "ec2_image_id" {
  description = "The name for the autoscaling group for the ECS cluster."
  default     = "ami-007ef488b3574da6b" # ECS optimized Linux in London created 16/10/2019
}

variable "asg_max_instance_count" {
  description = "The name for the autoscaling group for the cluster."
  default     = 1
}

variable "asg_min_instance_count" {
  description = "The name for the autoscaling group for the cluster."
  default     = 1
}

variable "asg_desired_instance_count" {
  description = "The name for the autoscaling group for the cluster."
  default     = 1
}

variable "ssl_certificate_id" {}
variable "zone_id" {}
variable "zone_name" {}
variable "external_top_level_domain" {}
variable "internal_top_level_domain" {}

variable "log_level" {
  description = "The log level for services to use: TRACE, DEBUG, INFO or ERROR"
  default     = "TRACE"
}

//---------------- START: Environment Secrets for services ---------------------

variable "secrets" {
  description = "The secrets to be added to Parameter Store"
  type        = map
}

//---------------- END: Environment Secrets for services ---------------------

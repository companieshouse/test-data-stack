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

# These vpcs are configured for development. Preprod and prod are overridden in the vars file.
variable "vpc_cidr" {
  default = {
    eu-west-2 = "10.75.0.0/16" #London
  }
}
# These vpcs are configured for development. Preprod and prod are overridden in the vars file.
variable "vpc_id" {
  default = {
    eu-west-2 = "vpc-074ff55ed5182e144" #London
  }
}

variable "environment" {}
variable "internal_cidrs" {}
variable "deploy_to" {}

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


//---------------- START: Environment Secrets for services ---------------------

variable "secrets" {
  description = "The secrets to be added to Parameter Store"
  type        = map
}

//---------------- END: Environment Secrets for services ---------------------

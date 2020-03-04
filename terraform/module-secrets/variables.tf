variable "stack_name" {}
variable "name_prefix" {}
variable "environment" {}

variable "kms_key_id" {}

//---------------- START: Environment Secrets for services ---------------------

variable "secrets" {
  description = "The secrets to be added to Parameter Store"
  type = map
}

//---------------- END: Environment Secrets for services ---------------------

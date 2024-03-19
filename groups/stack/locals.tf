locals {
  vpc_id            = data.terraform_remote_state.networks.outputs.vpc_id
  application_ids   = data.terraform_remote_state.networks.outputs.application_ids
  application_cidrs = data.terraform_remote_state.networks.outputs.application_cidrs
  public_ids        = data.terraform_remote_state.networks.outputs.public_ids
  public_cidrs      = data.terraform_remote_state.networks.outputs.public_cidrs

  internal_cidrs = values(data.terraform_remote_state.networks_common_infra.outputs.internal_cidrs)
  vpn_cidrs      = values(data.terraform_remote_state.networks_common_infra.outputs.vpn_cidrs)

  management_private_subnet_cidrs = values(data.terraform_remote_state.networks_common_infra_ireland.outputs.management_private_subnet_cidrs)

  stack_name       = "test-data"
  stack_fullname   = "${local.stack_name}-stack"
  name_prefix      = "${local.stack_name}-${var.environment}"

  public_lb_cidrs  = ["0.0.0.0/0"]
  lb_subnet_ids    = "${var.test_data_lb_internal ? local.application_ids : local.public_ids}" # place ALB in correct subnets
  lb_access_cidrs  = "${var.test_data_lb_internal ? concat(local.management_private_subnet_cidrs,split(",",local.application_cidrs)) : local.public_lb_cidrs }"
  app_access_cidrs = "${var.test_data_lb_internal ? concat(local.internal_cidrs,local.vpn_cidrs,local.management_private_subnet_cidrs,split(",",local.application_cidrs)) : concat(local.internal_cidrs,local.vpn_cidrs,local.management_private_subnet_cidrs,split(",",local.application_cidrs),split(",",local.public_cidrs)) }"

  concourse_access_cidrs = values(data.vault_generic_secret.shared_services_concourse_cidrs.data)
}

# ----------------------------------------------------------------------------------------------------------------------


# data "aws_kms_secrets" "secrets" {
#   for_each = var.secrets
#   secret {
#     name    = each.key
#     payload = each.value
#   }
# }
#
# resource "aws_ssm_parameter" "secret_parameters" {
#     for_each = data.aws_kms_secrets.secrets
# #    for_each = var.secrets
#     name  = "/${var.name_prefix}/${each.key}"
#     key_id = var.kms_key_id
#     description = each.key
#     type  = "SecureString"
#     overwrite = "true"
#     value = data.aws_kms_secrets.secrets[each.key].plaintext[each.key]
# }


resource "aws_ssm_parameter" "secret_parameters" {
    for_each = var.secrets
    name  = "/${var.name_prefix}/${each.key}"
    key_id = var.kms_key_id
    description = each.key
    type  = "SecureString"
    overwrite = "true"
    value = each.value
}

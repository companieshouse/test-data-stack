output "secrets" {
  value = {
  for secret in var.secrets:
  reverse(split("/",secret.path))[0] => secret.data["value"]
  }
}

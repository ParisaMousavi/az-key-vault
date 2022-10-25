variable "name" {
  type = string
}

variable "key_vault_id" {
  type = string
}
variable "key_type" {
  type    = string
  default = "RSA"
}
variable "key_size" {
  type    = number
  default = 4096
}
variable "key_opts" {
  type    = list(string)
  default = ["wrapKey", "unwrapKey"]
}
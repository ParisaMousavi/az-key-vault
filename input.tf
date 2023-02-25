variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "stage" {
  type = string
}

variable "soft_delete_retention_days" {
  type    = number
  default = 60
}

variable "purge_protection" {
  type    = bool
  default = false
}

variable "enabled_for_disk_encryption" {
  type    = bool
  default = false
}

variable "enabled_for_deployment" {
  type    = bool
  default = false
}

variable "enabled_for_template_deployment" {
  type    = bool
  default = false
}

variable "enable_rbac_authorization" {
  type    = bool
  default = false
}

variable "public_network_access_enabled" {
  description = "This is set to true usually when the Private Endpoint is used."
  type        = bool
  default     = false
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "additional_tags" {
  default = {}
  type    = map(string)
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
}

variable "object_ids" {
  type        = list(string)
  description = "List of identity/sp's object_ids to get full access."
}

variable "private_endpoint_config" {
  type = object({
    subnet_id             = optional(string, null)
    virtual_network_id    = optional(string, null)
    private_dns_zone_id   = optional(string, null)
    private_dns_zone_name = optional(string, null)
  })
}

variable "workload_identity_enabled" {
  type    = bool
  default = false
}

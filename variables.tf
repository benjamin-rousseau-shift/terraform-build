variable "region" {
  type = string
  default = "FR2"
}

variable "environment" {
  type = string
  default = "AZ"

}

variable "storage_access_key" {}

variable "backup_management_id" {
  type = string
  default = "ac4ce12d-aeb1-4718-992f-768486206f0e"
}

variable "enterprise" {
  type = string
  default = "SH"
}

variable "project" {
  type = string
  default = "PAFW"
}

variable "intl_project" {
  type = string
  default = "INTL"
}

variable "client" {
  type = string
  default = "RETS"
}

variable "azurelocation" {
  type = string
  default = "francecentral"
}

variable "IPAddressPrefix" {
  default = "10.99"
}

variable "FirewallVmName" {
  default = "shazfr2pafw1"
}

variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "admin_password" {}
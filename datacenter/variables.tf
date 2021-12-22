variable "region" {
  type    = string
  default = "FR2"
}
variable "environment" {
  type    = string
  default = "AZ"

}
variable "backup_management_id" {
  type    = string
  default = "ac4ce12d-aeb1-4718-992f-768486206f0e"
}
variable "enterprise" {
  type    = string
  default = "SH"
}
variable "project" {
  type    = string
  default = "PAFW"
}
variable "intl_project" {
  type    = string
  default = "INTL"
}
variable "client" {
  type    = string
  default = "RETS"
}
variable "azurelocation" {
  type    = string
  default = "francecentral"
}
variable "IPAddressPrefix" {
  default = "10.99"
}
variable "AKSAddressPrefix" {
  type = string
  default = "10.100"
}

variable "FirewallVmName" {
  default = "shazfr2pafw1"
}
variable "panorama" {}
variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "bootstrap_storage_account" {}
variable "bootstrap_resource_group" {}
variable "bootstrap_storage_share" { default = "bootstrap" }
variable "admin_panos" {}
variable "panorama_vm_authkey" {}
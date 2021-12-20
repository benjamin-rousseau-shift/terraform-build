variable "region" {
  type = string
  default = "FR2"
}

variable "environment" {
  type = string
  default = "AZ"

}

variable "backup_management_id" {
  type = string
  default = "262044b1-e2ce-469f-a196-69ab7ada62d3"
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
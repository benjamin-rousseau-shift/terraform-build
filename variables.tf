variable "region" {
  type = string
  default = "FR2"
}

variable "environment" {
  type = string
  default = "AZ"

}

variable "enterprise" {
  type = string
  default = "SH"
}

variable "project" {
  type = string
  default = "PAFW"
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
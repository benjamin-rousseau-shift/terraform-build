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
variable "pafw" {
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

variable "AKSIPAddressPrefix" {
  default = "10.100"
}

variable "FirewallVmName" {
  default = "shazfr2pafw1"
}
variable "admin_panos" {}
variable "ov_pa_psk" {}
variable "zi_cfr_psk" {}
variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "subscription_id" {}
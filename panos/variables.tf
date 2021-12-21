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
variable "admin_password" {}
variable "ov_pa_pub" {}
variable "ov_pa_psk" {}
variable "panos_pub_mgmt" {}
variable "panos_pub_untrust" {}
variable "panorama" {}
variable "domain_controller" {}
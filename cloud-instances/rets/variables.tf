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
variable "pafw" {
  type    = string
  default = "PAFW"
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
variable "panos_pub_ip" {}
variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "admin_password" {}


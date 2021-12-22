variable "AKS_WEB_VM_SIZE" {
  type        = string
  description = "The vm size used to populate the aks web."
  default     = "Standard_D2_v2"
}

variable "AKS_WEB_NODE_COUNT" {
  type        = number
  description = "The number of node of the AKS web."
  default     = 3
}

variable "AKS_WORKER_VM_SIZE" {
  type        = string
  description = "The vm size used to populate the aks web."
  default     = "Standard_D2_v2"
}

variable "AKS_WORKER_NODE_COUNT" {
  type        = number
  description = "The number of node of the AKS worker."
  default     = 3
}

variable "enterprise" {
  type    = string
  default = "SH"
}

variable "region" {
  type    = string
  default = "FR2"
}
variable "environment" {
  type    = string
  default = "AZ"

}
variable "pafw" {
  type    = string
  default = "PAFW"
}

variable "AKSAddressPrefix" {
  type = string
  default = "10.100"
}

variable "azurelocation" {
  type    = string
  default = "francecentral"
}

variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "subscription_id" {}
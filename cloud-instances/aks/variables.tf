variable "SHIFT_CLOUD_INSTANCE" {
  type        = string
  description = "The name of the cloud instance to build."
}

variable "SP_CLIENT_ID" {
  type        = string
  description = "The client id used for accessing the azure subscription."
}

variable "SP_CLIENT_SECRET" {
  type        = string
  description = "The client secret used for accessing the azure subscription."
}


variable "INSTANCE_CLOUD_RESOURCE_GROUP_NAME" {
  type        = string
  description = "The name of the instance of the resource group."
}

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

variable "AKS_WEB_SUBNET_ID" {
  type        = string
  description = "The id of the subnet for the aks web."
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

variable "AKS_WORKER_SUBNET_ID" {
  type        = string
  description = "The id of the subnet for the aks worker."
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
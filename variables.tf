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
variable "FirewallVmName" {
  default = "shazfr2pafw1"
}
variable "files" {
  description = <<-EOF
  Map of all files to copy to bucket. The keys are local paths, the values are remote paths.
  Always use slash `/` as directory separator (unix-like), not the backslash `\`.
  For example `{"dir/my.txt" = "config/init-cfg.txt"}`
  EOF
  default     = {
    "config/init-cfg.txt" = "config/init-cfg.txt"
  }
  type        = map(string)
}

variable "files_md5" {
  description = <<-EOF
  Optional map of MD5 hashes of file contents.
  Normally the map could be all empty, because all the files that exist before the `terraform apply` will have their hashes auto-calculated.
  This input is necessary only for the selected files which are created/modified within the same Terraform run as this module.
  The keys of the map should be identical with selected keys of the `files` input, while the values should be MD5 hashes of the contents of that file.
  For example `{"dir/my.txt" = "6f7ce3191b50a58cc13e751a8f7ae3fd"}`
  EOF
  default     = {}
  type        = map(string)
}
variable "client_id" {}
variable "tenant_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "admin_password" {}
variable "bootstrap_storage_account" {}
variable "bootstrap_resource_group" {}
variable "bootstrap_storage_share" { default = "boostrap" }

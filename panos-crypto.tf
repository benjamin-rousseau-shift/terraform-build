resource "panos_ike_crypto_profile" "default" {
  name = "AES-128-SHA256-G2-86400"
  dh_groups = ["group2"]
  authentications = ["SHA256"]
  encryptions = ["aes-168-cbc"]
  lifetime_value = 24
  authentication_multiple = 0
}
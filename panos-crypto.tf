resource "panos_ike_crypto_profile" "example" {
  name = "example"
  dh_groups = ["group1", "group2"]
  authentications = ["md5", "sha1"]
  encryptions = ["des"]
  lifetime_value = 8
  authentication_multiple = 3
}
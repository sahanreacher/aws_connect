resource "aws_connect_instance" "test" {
  identity_management_type = "SAML"
  inbound_calls_enabled    = true
  instance_alias           = "aubhi-tester"
  outbound_calls_enabled   = true
  multi_party_conference_enabled = true
  early_media_enabled = true
}

# Additionally, you'll need to configure your Connect instance to use SAML for identity management 
# you also need to add a trust relationship between your Connect instance and the IAM Identity Center application.


##########################
#### connecttelephony ####
##########################

data "template_file" "kms_key_policy_connecttelephony" {
  template = file("${path.module}/connecttelephony.tpl")
  vars = {
    env                          = lower(var.env)
    service_code                 = lower(var.service["code"])
    account_id                   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_kms_key" "kms_key_connecttelephony" {
  description             = "A Key to encrypt connect resources"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = false
  policy                  = data.template_file.kms_key_policy_connecttelephony.rendered
  multi_region            = false 
  tags = merge(
    {
      
      "Name"  = "${upper(local.name_prefix2)}CONKMS001",
      "Product" = "DEFRA Connect Platform"
      "Description" = "key to encrypt connect resources"
      "Environment" = lower(var.env)
      "Alias" = "${upper(local.name_prefix2)}CONKMS001"
    },
  local.required_tags)

}
resource "aws_kms_alias" "kms_key_alias_connecttelephony" {
  name          = "alias/${upper(local.name_prefix2)}CONKMS001"
  target_key_id = aws_kms_key.kms_key_connecttelephony.key_id
}

#################
#### kinesis ####
#################

data "template_file" "kms_key_policy_kinesis" {
  template = file("${path.module}/kinesis.tpl")
  vars = {
    env                          = lower(var.env)
    service_code                 = lower(var.service["code"])
    account_id                   = data.aws_caller_identity.current.account_id
  }
}

resource "aws_kms_key" "kms_key_kinesis" {
  description             = "Kinesis key for CTR and agentevents"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = false
  policy                  = data.template_file.kms_key_policy_kinesis.rendered
  multi_region            = false 
  tags = merge(
    {
      
      "Name"  = "${upper(local.name_prefix2)}KINKMS001",
      "Product" = "DEFRA Connect Platform"
      "Description" = "Kinesis key for CTR and agentevents"
      "Environment" = lower(var.env)
      "Alias" = "${upper(local.name_prefix2)}KINKMS001"
    },
  local.required_tags)

}
resource "aws_kms_alias" "kms_key_alias_kinesis" {
  name          = "alias/${upper(local.name_prefix2)}KINKMS001"
  target_key_id = aws_kms_key.kms_key_kinesis.key_id
}


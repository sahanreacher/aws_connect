output "kms_con_key_id" {
  value = aws_kms_key.kms_key_connecttelephony.key_id
}

output "kms_con_key_arn" {
  value = aws_kms_key.kms_key_connecttelephony.arn
}

output "kms_kin_key_id" {
  value = aws_kms_key.kms_key_kinesis.key_id
}

output "kms_kin_key_arn" {
  value = aws_kms_key.kms_key_kinesis.arn
}
output "con_bucket_arn" {
  value = module.s3_bucket_con.s3_bucket_arn
}

output "con_bucket_name" {
  value = module.s3_bucket_con.s3_bucket_id
}
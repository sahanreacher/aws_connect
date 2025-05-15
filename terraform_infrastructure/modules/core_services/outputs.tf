#output "s3_bucket_telephony_arn" {
#    description = "ARN of the Telephony S3 bucket"
#    value       = aws_s3_bucket.telephony.arn
#}

output "s3_bucket_telephony_id" {
    description = "ID of the Telephony S3 bucket"
    value       = aws_s3_bucket.telephony.id
}


output "connect_instance_id" {
    description = "ID of the AWS Connect Instance"
    value       = "${aws_connect_instance.instance.id}"
}

output "connect_instance_arn" {
    description = "ARN of the AWS Connect Instance"
    value       = "${aws_connect_instance.instance.arn}"
}
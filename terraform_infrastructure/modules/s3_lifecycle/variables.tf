variable "environment" {
    description = "Deployed environment"
    type        = string
}

variable "project" {
    default     = "inf"
    description = "Project"
    type        = string
}


variable "s3_bucket_telephony_id" {
    description = "ID of the Telephony S3 bucket"
    type        = string
}
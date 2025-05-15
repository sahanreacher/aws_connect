
variable "environment" {
    description = "Deployed environment"
    type        = string
}


variable "product" {
    default     = "Defra Connect Platform"
    description = "Product"
    type        = string
}


variable "project" {
    default     = "inf"
    description = "Project"
    type        = string
}


variable "retention_period" {
    default     = 24
    description = "Data retention period in hours"
    type        = number
}






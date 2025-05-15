variable "environment" {
    description = "Deployed environment"
    type        = string
}


variable "private_subnet_count" {
    default     = 1
    description = "Number of private subnets to create"
    type        = number
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


variable "public_subnet_count" {
    default     = 2
    description = "Number of pulic subnets to create"
    type        = number
}


variable "region" {
    description = "AWS Region"
    type        = string
}


variable "vpc_cidr_block" {
    description = "VPC CIDR"
    type        = string
}

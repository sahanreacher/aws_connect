###################################
# EC2_ INSTANCES MODULE VARIABLES #
###################################

#################################
# Variable Declaration Template #
#################################

/*
variable "" {
  type = ""
  description =""
}
*/

#################################

variable "region" {
  type        = string
  description = "The AWS Region to deploy infrastructure"
}

variable "env" {
  type        = string
  description = "The 3 letter acronym denoting the  environment DEV, TST, PRE, PRD"
}

variable "environment" {
  type        = string
  description = "A string for the Environment used in the terragrunt repository directory structure. E.g development, test, aps_shared_service. ect"
}

variable "service" {
  type        = map(string)
  description = "A Map of service details, Name, Type and Code"
}

variable "account_id" {
  type        = map(string)
  description = "A map of account IDs for our AWS accounts, Ops, Aps, ect."
}

variable "loc" {
  description = "A string containing the region Code e.g LDN"
}



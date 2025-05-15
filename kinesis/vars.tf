####################
# MODULE VARIABLES #
####################

#################################
# Variable Declaration Template #
#################################

/*
variable "" {
  type = ""
  description = ""
}
*/

#################################
variable "account_id" {
  type        = map(string)
  description = "A map of our AWS account IDs"
}

variable "service" {
  type        = map(string)
  description = "A map of service details, Name, Type and Code"
}

variable "region" {
  type        = string
  description = "a string holding AWS Region in which to provision infrastructure. E.g. eu-west-1"
}

variable "env" {
  type        = string
  description = "Three letter Environment descriptor. E.g. SND, DEV, TST, PRE, PRD"
}

variable "environment" {
  type        = string
  description = "A string for the Environment used in the terragrunt repository directory structure. E.g development, test, aps_shared_service. ect"
}

variable "loc" {
  type        = string
  description = "Location of eu Region"
}

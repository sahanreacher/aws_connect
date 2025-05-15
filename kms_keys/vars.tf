#
# MODULE VARIABLES #
#

#
# Variable Declaration Template #
#

/*
variable "" {
  type = ""
  description = ""
}
*/

#
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

variable "location" {
  type        = string
  description = "A string containing the region Name = London"
}

variable "loc" {
  type        = string
  description = "A string containing the region Code e.g LDN"
}

variable "account_id" {
  type        = map(string)
  description = "A map of strings containing 3 letter code and the associated account id number"
}

variable "ecs_task_fail_name" {
  type        = string
  description = "Name of ECS task fail generally"
  default     = "ecs-task-fail"
}

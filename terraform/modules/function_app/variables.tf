variable "function_app_name" {
  type        = string
  description = "The name of the Function App"
}

variable "location" {
  type        = string
  description = "The Azure region where the Function App will be hosted"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

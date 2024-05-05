variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
  default     = "InbodyDashboardApp"
}

variable "location" {
  type        = string
  description = "The Azure region where the resource group should be created"
  default     = "East US"
}

variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "The object ID for the Azure AD entity that will access the Key Vault"
  type        = string
}

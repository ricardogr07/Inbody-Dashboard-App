variable "key_vault_name" {
  description = "The name of the key vault"
  type        = string
}

variable "location" {
  description = "The location for the key vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
}

variable "object_id" {
  description = "The object ID for the Azure AD entity (user or group) that will access the Key Vault"
  type        = string
}

variable "cosmos_db_connection_string" {
  description = "The primary connection string for Cosmos DB"
  type        = string
}

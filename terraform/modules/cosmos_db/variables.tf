variable "name" {
  description = "The name of the Cosmos DB account"
  type        = string
}

variable "location" {
  description = "The primary location for the Cosmos DB account"
  type        = string
}

variable "failover_location" {
  description = "The failover location for the Cosmos DB account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB account"
  type        = string
}

variable "database_name" {
  description = "The name of the Cosmos DB database"
  type        = string
}

variable "container_name" {
  description = "The name of the Cosmos DB container"
  type        = string
}

variable "partition_key_path" {
  description = "The path of the partition key"
  type        = string
}

variable "throughput" {
  description = "The RU/s (Request Units per second) for the database"
  default     = 400
  type        = number
}

variable "container_throughput" {
  description = "The RU/s for the container"
  default     = 400
  type        = number
}

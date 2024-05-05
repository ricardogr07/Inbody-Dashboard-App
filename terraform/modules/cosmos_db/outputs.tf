output "cosmos_db_account_id" {
  value = azurerm_cosmosdb_account.cosmos_db.id
}

output "cosmos_db_account_endpoint" {
  value = azurerm_cosmosdb_account.cosmos_db.endpoint
}

output "cosmos_db_account_primary_master_key" {
  value = azurerm_cosmosdb_account.cosmos_db.primary_key
}

output "cosmos_db_sql_database_id" {
  value = azurerm_cosmosdb_sql_database.sql_database.id
}

output "cosmos_db_sql_container_id" {
  value = azurerm_cosmosdb_sql_container.sql_container.id
}

output "cosmos_db_primary_connection_string" {
  description = "Primary SQL connection string for Cosmos DB"
  value       = "AccountEndpoint=${azurerm_cosmosdb_account.cosmos_db.endpoint};AccountKey=${azurerm_cosmosdb_account.cosmos_db.primary_key};"
  sensitive   = true
}

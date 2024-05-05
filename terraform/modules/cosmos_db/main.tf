resource "azurerm_cosmosdb_account" "cosmos_db" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"  # or other kinds depending on your needs

  consistency_policy {
    consistency_level       = "Session"  # or BoundedStaleness, Eventual, etc., based on your requirements
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = var.failover_location
    failover_priority = 1
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "sql_database" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos_db.name
  throughput          = var.throughput
}

resource "azurerm_cosmosdb_sql_container" "sql_container" {
  name                = var.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos_db.name
  database_name       = azurerm_cosmosdb_sql_database.sql_database.name

  partition_key_path = var.partition_key_path
  throughput         = var.container_throughput

}

data "azurerm_cosmosdb_account" "cosmos_db" {
  name                = var.name
  resource_group_name = var.resource_group_name
}

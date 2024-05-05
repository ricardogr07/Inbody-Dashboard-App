provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "cosmos_db" {
  source              = "./modules/cosmos_db"
  name                = "inbodydashboardapp-cosmosdb"
  location            = azurerm_resource_group.rg.location
  failover_location   = "West US"
  resource_group_name = azurerm_resource_group.rg.name
  database_name       = "inbodydashboardapp-database"
  container_name      = "inbodydashboardapp-container"
  partition_key_path  = "/id"
  throughput          = 400
  container_throughput = 400
}

module "key_vault" {
  source              = "./modules/key_vault"
  key_vault_name      = "inbodyapp-keyvault"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  object_id           = var.object_id
  cosmos_db_connection_string = module.cosmos_db.cosmos_db_primary_connection_string
}

module "function_app" {
  source              = "./modules/function_app"
  function_app_name   = "inbodydashboardapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "blob_storage" {
  source              = "./modules/blob_storage"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_name = "inbodyapppdfstore"
  container_name = "pdfs"
}

resource "azurerm_storage_account" "function_sa" {
  name                     = "${var.function_app_name}sa"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function_plan" {
  name                = "${var.function_app_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = "Dynamic"
    size = "Y1"  // Consumption plan
  }
}

resource "azurerm_function_app" "function_app" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.function_plan.id
  storage_account_name= azurerm_storage_account.function_sa.name
  storage_account_access_key = azurerm_storage_account.function_sa.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AzureWebJobsStorage" = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.function_sa.name};AccountKey=${azurerm_storage_account.function_sa.primary_access_key}"
    "FUNCTIONS_EXTENSION_VERSION" = "~3"
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"  // Change this depending on your function runtime; could be node, java, python, etc.
  }

  site_config {
    cors {
      allowed_origins = ["*"]
    }
  }
}

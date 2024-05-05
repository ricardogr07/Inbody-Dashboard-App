resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku_name                    = "standard"
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = true

  access_policy {
    tenant_id                 = var.tenant_id
    object_id                 = var.object_id

    key_permissions = [
      "Get",
      "Create",
      "Delete",
      "List",
      "Update",
      "Import",
      "Backup",
      "Restore",
      "Recover",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Delete",
      "Create",
      "Import",
      "Update",
      "ManageContacts",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers"
    ]
  }
}

resource "azurerm_key_vault_secret" "cosmos_db_secret" {
  name            = "cosmos-db-connection-string"
  value           = var.cosmos_db_connection_string
  key_vault_id    = azurerm_key_vault.key_vault.id
  depends_on      = [azurerm_key_vault.key_vault]
}

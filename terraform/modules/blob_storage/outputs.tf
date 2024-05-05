output "storage_account_name" {
  value = azurerm_storage_account.pdf_storage.name
}

output "blob_container_name" {
  value = azurerm_storage_container.pdf_container.name
}

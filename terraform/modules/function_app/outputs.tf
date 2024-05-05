output "function_app_id" {
  value = azurerm_function_app.function_app.id
}

output "function_app_default_hostname" {
  value = azurerm_function_app.function_app.default_hostname
}

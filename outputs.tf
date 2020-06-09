data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

output "current_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "app_id" {
  value = azuread_application.cdp.application_id
}

output "sp_password" {
  value     = azuread_application_password.cdp.value
  sensitive = false
}

resource "azurerm_storage_account" "cdp" {
  name                     = "st${var.prefix}"
  resource_group_name      = azurerm_resource_group.cdp.name
  location                 = azurerm_resource_group.cdp.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  account_kind             = "StorageV2"

  tags = merge(local.common_tags)
}

resource "azurerm_storage_container" "cdp_logs" {
  name                  = "logs"
  storage_account_name  = azurerm_storage_account.cdp.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cdp_data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.cdp.name
  container_access_type = "private"
}

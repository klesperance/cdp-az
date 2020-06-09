resource "azurerm_user_assigned_identity" "cdp-data_access" {
  resource_group_name = azurerm_resource_group.cdp.name
  location            = azurerm_resource_group.cdp.location
  name                = "${var.prefix}-DataAccessIdentity"

  tags = merge(local.common_tags)
}

resource "azurerm_user_assigned_identity" "cdp-logger" {
  resource_group_name = azurerm_resource_group.cdp.name
  location            = azurerm_resource_group.cdp.location
  name                = "${var.prefix}-LoggerIdentity"

  tags = merge(local.common_tags)
}

resource "azurerm_user_assigned_identity" "cdp-assumer" {
  resource_group_name = azurerm_resource_group.cdp.name
  location            = azurerm_resource_group.cdp.location
  name                = "${var.prefix}-AssumerIdentity"

  tags = merge(local.common_tags)
}

resource "azurerm_user_assigned_identity" "cdp-ranger" {
  resource_group_name = azurerm_resource_group.cdp.name
  location            = azurerm_resource_group.cdp.location
  name                = "${var.prefix}-RangerIdentity"

  tags = merge(local.common_tags)
}

resource "azurerm_role_assignment" "cdp-assumer-identityoperator" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.cdp-assumer.principal_id
}

resource "azurerm_role_assignment" "cdp-assumer-vmcontributor" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.cdp-assumer.principal_id
}

resource "azurerm_role_assignment" "cdp-logger-logs" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.cdp.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.cdp.name}/blobServices/default/containers/logs"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.cdp-logger.principal_id
}

resource "azurerm_role_assignment" "cdp-data_access-data" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.cdp.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.cdp.name}/blobServices/default/containers/data"
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.cdp-data_access.principal_id
}

resource "azurerm_role_assignment" "cdp-data_access-logs" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.cdp.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.cdp.name}/blobServices/default/containers/logs"
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_user_assigned_identity.cdp-data_access.principal_id
}

resource "azurerm_role_assignment" "cdp-ranger-data" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.cdp.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.cdp.name}/blobServices/default/containers/data"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.cdp-data_access.principal_id
}

resource "azurerm_network_security_group" "cdp" {
  name                = "nsg-${var.prefix}"
  location            = azurerm_resource_group.cdp.location
  resource_group_name = azurerm_resource_group.cdp.name
  tags                = merge(local.common_tags)
}

resource "azurerm_network_ddos_protection_plan" "cdp" {
  name                = "ddos-${var.prefix}"
  location            = azurerm_resource_group.cdp.location
  resource_group_name = azurerm_resource_group.cdp.name
  tags                = merge(local.common_tags)
}

# 1 subnet required for Data Lake and Data Hub clusters.  4 Subnets required for Machine Learning or Data Warehouse clusters
resource "azurerm_subnet" "cdp" {
  name                 = "subnet-${var.prefix}"
  resource_group_name  = azurerm_resource_group.cdp.name
  virtual_network_name = azurerm_virtual_network.cdp.name
  address_prefixes     = ["10.1.32.0/19"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]

}

resource "azurerm_virtual_network" "cdp" {
  name                = "vnet-${var.prefix}"
  location            = azurerm_resource_group.cdp.location
  resource_group_name = azurerm_resource_group.cdp.name
  address_space       = ["10.1.0.0/16"]

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.cdp.id
    enable = true
  }

  tags = merge(local.common_tags)
}

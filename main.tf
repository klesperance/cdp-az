locals {
  common_tags = "${map(
    "owner", "${var.owner}", "dept", "${var.dept}", "project", "${var.project}", "enddate", "${var.enddate}"
  )}"
}

resource "azurerm_resource_group" "cdp" {
  name     = "rg-${var.prefix}"
  location = var.location
  tags     = merge(local.common_tags)
}

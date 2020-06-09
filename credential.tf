resource "azuread_application" "cdp" {
  name                       = var.prefix
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "cdp" {
  application_id = azuread_application.cdp.application_id

  # tags = merge(local.common_tags)
}

resource "random_string" "cdp_password" {
  length  = 32
  special = true
}

/*
resource "azuread_service_principal_password" "cdp" {
	end_date = "2299-12-30T23:00:00Z"                        # Forever
	service_principal_id = azuread_service_principal.cdp.id
	value = random_string.cdp_password.result

        tags = merge(local.common_tags)
}
*/

resource "azuread_application_password" "cdp" {
  application_object_id = azuread_application.cdp.object_id
  value                 = random_string.cdp_password.result
  end_date              = "2299-12-30T23:00:00Z"
}

resource "azurerm_role_assignment" "cdp" {
  scope                            = "/subscriptions/${var.subscription_id}"
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.cdp.id
  skip_service_principal_aad_check = true
}

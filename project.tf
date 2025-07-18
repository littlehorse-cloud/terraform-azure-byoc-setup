data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "lh_group" {
  name     = local.resource_group_name
  location = local.location
}

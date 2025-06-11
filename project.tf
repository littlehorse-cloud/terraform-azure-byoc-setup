data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {}
resource "azurerm_resource_group" "lh_group" {
  name     = local.resource_group_name
  location = local.location
}

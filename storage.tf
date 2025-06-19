resource "azurerm_storage_account" "terraform_state" {
  name                            = "lhterraformstate${substr(var.subscription_id, 0, 6)}"
  resource_group_name             = local.resource_group_name
  location                        = local.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  depends_on                      = [azurerm_resource_group.lh_group]
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "lh-byoc-terraform-state"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

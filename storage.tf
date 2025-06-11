resource "azurerm_storage_account" "terraform_state" {
  name                     = "lhterraformstate${substr(var.subscription_id, 0, 6)}"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  depends_on               = [azurerm_resource_group.lh_group]
}

output "byoc_setup_details" {
  description = "BYOC setup details"
  value = {
    bucket_name      = azurerm_storage_account.terraform_state.name
    subscription_id  = var.subscription_id
    azure_client_id  = azuread_application_registration.github_actions.client_id
    tenant_id        = data.azuread_client_config.current.tenant_id
    application_name = azuread_application_registration.github_actions.display_name
  }
}

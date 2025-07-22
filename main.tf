resource "azuread_application_registration" "github_actions" {
  display_name = "littlehorse-app-${substr(var.subscription_id, 0, 6)}"
}

resource "azuread_application_federated_identity_credential" "main_branch" {
  application_id = azuread_application_registration.github_actions.id
  display_name   = "github-actions-main-branch"
  description    = "Federated credentials for GitHub Actions on the main branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.organization_name}/${var.repository_name}:ref:refs/heads/main"
  depends_on     = [azuread_application_registration.github_actions]
}

resource "azuread_service_principal" "github_sa" {
  client_id = azuread_application_registration.github_actions.client_id
}

resource "azurerm_role_assignment" "github_sa_custom_role_assignment" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = azurerm_role_definition.custom_role.name
  principal_id         = azuread_service_principal.github_sa.object_id
  depends_on           = [azurerm_role_definition.custom_role]
}

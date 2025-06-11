resource "random_id" "identity_pool_id" {
  byte_length = 4
}
resource "azuread_application_registration" "github_actions" {
  display_name = "littlehorse-app-${random_id.identity_pool_id.hex}"
}

resource "azuread_application_federated_identity_credential" "main_branch" {
  application_id = azuread_application_registration.github_actions.id
  display_name   = "github-actions-main-branch"
  description    = "Federated credentials for GitHub Actions on the main branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.organization_name}/${var.repository_name}:ref:refs/heads/main"
}

resource "azuread_service_principal" "github_sa" {
  client_id = azuread_application_registration.github_actions.client_id
}

resource "azurerm_role_assignment" "github_sa_roll" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_sa.object_id
}

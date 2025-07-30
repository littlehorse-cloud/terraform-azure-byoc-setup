variables {
  repository_name   = "repo-name"
  organization_name = "example-org"
  subscription_id   = "8f930fc9-57bd-411b-afc7-cfe952a8e2e1"
  location          = "East US"
  suffix_length     = 8
}
mock_provider "azurerm" {
}

mock_provider "azuread" {

}

run "empty_input_validation" {
  command = plan

  variables {
    repository_name   = ""
    organization_name = ""
    subscription_id   = ""
  }

  expect_failures = [var.repository_name, var.organization_name, var.subscription_id]
}

run "null_input_validation" {
  command = plan

  variables {
    repository_name   = null
    organization_name = null
    subscription_id   = null
  }

  expect_failures = [var.repository_name, var.organization_name, var.subscription_id]
}

run "check_resource_group" {
  command = plan

  assert {
    condition     = azurerm_resource_group.lh_group.name == local.resource_group_name
    error_message = "Resource group name does not match expected value"
  }

  assert {
    condition     = azurerm_resource_group.lh_group.location == local.location
    error_message = "Resource group location does not match expected value"
  }
}

run "check_azurerm_storage_account" {
  command = plan
  assert {
    condition     = azurerm_storage_account.terraform_state.name == "lhterraformstate8f930fc9"
    error_message = "Incorrect bucket name"
  }

  assert {
    condition     = azurerm_storage_account.terraform_state.allow_nested_items_to_be_public == false
    error_message = "Nested items must not be public"
  }

}

run "check_terraform_state_container" {
  command = plan

  assert {
    condition     = azurerm_storage_container.terraform_state_container.name == "lh-byoc-terraform-state"
    error_message = "Incorrect storage container name"
  }

  assert {
    condition     = azurerm_storage_container.terraform_state_container.container_access_type == "private"
    error_message = "Storage container access type must be private"
  }

  assert {
    condition     = azurerm_storage_container.terraform_state_container.storage_account_name == azurerm_storage_account.terraform_state.name
    error_message = "Storage container must be associated with the correct storage account"
  }
}

run "check_application_registration_name" {
  command = plan
  assert {
    condition     = azuread_application_registration.github_actions.display_name == "littlehorse-app-8f930fc9"
    error_message = "Incorrect application registration display name"
  }
}

run "check_federated_identity_credential" {
  command = plan

  assert {
    condition     = azuread_application_federated_identity_credential.main_branch.subject == "repo:${var.organization_name}/${var.repository_name}:ref:refs/heads/main"
    error_message = "Incorrect subject for federated identity credential"
  }

  assert {
    condition     = azuread_application_federated_identity_credential.main_branch.audiences[0] == "api://AzureADTokenExchange"
    error_message = "Incorrect audience for federated identity credential"
  }

  assert {
    condition     = azuread_application_federated_identity_credential.main_branch.issuer == "https://token.actions.githubusercontent.com"
    error_message = "Incorrect issuer for federated identity credential"
  }
}

run "check_custom_role_definition" {
  command = plan

  assert {
    condition     = azurerm_role_definition.custom_role.name == "LittleHorse BYOC 8f930fc9"
    error_message = "Custom role name does not match expected value"
  }

  assert {
    condition     = azurerm_role_definition.custom_role.scope == "/subscriptions/${var.subscription_id}"
    error_message = "Custom role scope does not match subscription ID"
  }

  assert {
    condition     = length(azurerm_role_definition.custom_role.permissions[0].actions) > 0
    error_message = "Custom role permissions actions should not be empty"
  }

  assert {
    condition     = azurerm_role_definition.custom_role.assignable_scopes[0] == "/subscriptions/${var.subscription_id}"
    error_message = "Custom role assignable scopes do not match expected value"
  }

  assert {
    condition     = length(azurerm_role_definition.custom_role.permissions[0].data_actions) > 0
    error_message = "Custom role data actions should not be empty"
  }
}

run "check_custom_role_assignments" {
  command = plan

  assert {
    condition     = azurerm_role_assignment.github_sa_custom_role_assignment.role_definition_name == azurerm_role_definition.custom_role.name
    error_message = "Role assignment does not match custom role definition"
  }

  assert {
    condition = azurerm_role_assignment.github_sa_custom_role_assignment.scope == "/subscriptions/${var.subscription_id}"
    error_message = "Role assignment scope does not match subscription ID"
  }
}

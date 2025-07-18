variables {
  repository_name   = "repo-name"
  organization_name = "example-org"
  subscription_id   = "11111111-2222-3333-4444-555555555555"
  location          = "East US"
}

mock_provider "azurerm" {
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

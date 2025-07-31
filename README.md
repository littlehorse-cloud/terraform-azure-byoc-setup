# Littlehorse Azure BYOC Setup

## Install via cloud shell

The script only needs the repository name as a parameter, the resource location is optional (The default is "Central US").

Run the script

**Note: the repository name assumes the prefix `azure-byoc-<REPOSITORY_NAME>`**

```sh
curl -sS -O https://raw.githubusercontent.com/littlehorse-cloud/terraform-azure-byoc-setup/main/scripts/setup.sh  && sh setup.sh <REPOSITORY_NAME> <LOCATION>
```

Once the process ends, please share the output with the sales representative.

## Releases

The releases of this module are automated with `git-cliff`.

## How to contribute

### Requirements

- pre-commit `pip install pre-commit`
- hcledit `brew install minamijoyo/hcledit/hcledit`
- tflint `brew install tflint`

Make sure to install pre-commit

```sh
pre-commit install
```

## How to run tests

Go to the root of the project and run:

```sh
terraform test
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application_federated_identity_credential.main_branch](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_application_registration.github_actions](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_registration) | resource |
| [azuread_service_principal.github_sa](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_resource_group.lh_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.github_sa_custom_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.custom_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_storage_account.terraform_state](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.terraform_state_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure region where resources will be created. | `string` | `"East US"` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the GitHub organization to be used for Azure AD App registration. | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the GitHub repository to be used for Azure AD App registration. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. | `string` | n/a | yes |
| <a name="input_suffix_length"></a> [suffix\_length](#input\_suffix\_length) | The length of the suffix to be used in resource names. | `number` | `8` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_byoc_setup_details"></a> [byoc\_setup\_details](#output\_byoc\_setup\_details) | BYOC setup details |
<!-- END_TF_DOCS -->

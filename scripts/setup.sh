#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Use: $0 <REPOSITORY_NAME> OPTIONAL:<LOCATION>"
  exit 1
fi

REPOSITORY_NAME="$1"
LOCATION=${2:-"Central US"}
ORGANIZATION_NAME="littlehorse-cloud"


MODULE_VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/littlehorse-cloud/terraform-azure-byoc-setup.git | grep -v '\^{}' | tail -n1 | sed 's/.*\///; s/^v//')"

WORKDIR="tf-byoc-module"

# if workdir exists then exit with error
if [ -d "$WORKDIR" ]; then
  echo "Error: There is an existing state, if you want to preserve state then run terraform from within ./$WORKDIR folder, otherwise delete the folder and try again."
  exit 1
fi

mkdir -p "$WORKDIR"
cd "$WORKDIR"

cat >main.tf <<EOF
module "setup_byoc" {
  source  = "littlehorse-cloud/byoc-setup/azure"
  version = "$MODULE_VERSION"

  subscription_id   = var.subscription_id
  repository_name   = "azure-byoc-$REPOSITORY_NAME"
  organization_name = "$ORGANIZATION_NAME"
  location          = "$LOCATION"
}

variable "subscription_id" {
 type = string
 description = "The Azure subscription ID."
}

output "byoc_setup_details" {
 value = module.setup_byoc.byoc_setup_details
 description = "Details of the BYOC setup."
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {}

EOF

export TF_VAR_subscription_id=$(az account show --query id -o tsv 2>/dev/null)

if [[ -z "$TF_VAR_subscription_id" ]]; then
    echo "Error get azure account. Make sure you are logged in to Azure (run 'az login') and that az CLI is installed."
    exit 1
fi

terraform init
terraform apply -auto-approve

echo "Setup complete."

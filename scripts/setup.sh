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

echo "Fetching list of Azure subscriptions..."

mapfile -t subscriptions < <(az account list --query "[].name" -o tsv)

if [ ${#subscriptions[@]} -eq 0 ]; then
    echo "No subscriptions found."
    exit 1
fi

echo "Please select the subscription you want to use:"
select sub_name in "${subscriptions[@]}"; do
    if [ -n "$sub_name" ]; then
        read -p "You have selected '$sub_name'. Are you sure? (y/n) " -n 1 -r
        echo 

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            az account set --subscription "$sub_name"
            echo "Subscription set to: $sub_name"
            break
        else
            echo "Selection cancelled. Please choose a subscription again."
        fi
    else
        echo "Invalid selection. Please try again."
    fi
done

export TF_VAR_subscription_id=$(az account show --query id -o tsv 2>/dev/null)

terraform init
terraform apply -auto-approve

echo "Setup complete."

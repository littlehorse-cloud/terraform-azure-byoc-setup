#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Use: $0 <REPOSITORY_NAME> OPTIONAL:<LOCATION>"
  exit 1
fi

REPOSITORY_NAME="$1"
LOCATION=${2:-"East US"} 
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
  repository_name   = "gcp-byoc-$REPOSITORY_NAME"
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

provider "google" {
 project = var.project_id
}

EOF

if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI (az) is not installed. Please install it and try again."
    exit 1
fi

export TF_VAR_subscription_id=$(az account show --query id -o tsv 2>/dev/null)

terraform init
terraform apply -auto-approve

echo "Setup complete."
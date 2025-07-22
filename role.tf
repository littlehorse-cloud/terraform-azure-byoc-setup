resource "azurerm_role_definition" "custom_role" {
  name              = "LittleHorse BYOC"
  scope             = "/subscriptions/${var.subscription_id}"
  assignable_scopes = ["/subscriptions/${var.subscription_id}"]
  description       = "Role for deploying LittleHorse BYOC Infrastructure"
  permissions {
    actions = [
      "Microsoft.ContainerService/managedClusters/*",
      "Microsoft.Network/virtualNetworks/*",
      "Microsoft.Network/networkInterfaces/*",
      "Microsoft.Network/publicIPAddresses/*",
      "Microsoft.Network/loadBalancers/*",
      "Microsoft.Network/networkSecurityGroups/*",
      "Microsoft.Network/dnsZones/*",
      "Microsoft.Network/privateDnsZones/*",
      "Microsoft.Network/privateDnsZones/virtualNetworkLinks/*",
      "Microsoft.ManagedIdentity/userAssignedIdentities/*",
      "Microsoft.Resources/deployments/*",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Authorization/roleAssignments/*",
      "Microsoft.Authorization/roleDefinitions/write",
      "Microsoft.Authorization/roleDefinitions/delete",
      "Microsoft.KeyVault/vaults/*",
      "Microsoft.KeyVault/vaults/secrets/*",
      "Microsoft.KeyVault/vaults/keys/*",
      "Microsoft.ContainerRegistry/registries/*",
      "Microsoft.ContainerRegistry/registries/listCredentials/action",
      "Microsoft.ContainerRegistry/registries/generateCredentials/action"
    ]
  }
}

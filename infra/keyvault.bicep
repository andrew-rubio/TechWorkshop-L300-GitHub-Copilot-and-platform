param name string
param location string

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    enablePurgeProtection: true
  }
}

output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name

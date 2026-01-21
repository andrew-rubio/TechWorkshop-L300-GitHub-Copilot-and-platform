param name string
param location string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
  kind: 'Windows'
  properties: {
    reserved: false
  }
}

output appServicePlanId string = appServicePlan.id
output appServicePlanName string = appServicePlan.name

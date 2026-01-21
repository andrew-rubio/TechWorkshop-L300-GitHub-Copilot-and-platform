param name string
param location string
param serverFarmId string

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: serverFarmId
    httpsOnly: true
  }
}
output appServiceId string = appService.id
output appServiceName string = appService.name

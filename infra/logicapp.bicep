param name string
param location string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: name
  location: location
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {}
      triggers: {}
      outputs: {}
    }
    parameters: {}
  }
}

output logicAppId string = logicApp.id
output logicAppName string = logicApp.name

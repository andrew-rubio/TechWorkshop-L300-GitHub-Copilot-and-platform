param name string
param location string
param logAnalyticsWorkspaceId string
param logAnalyticsWorkspaceKey string

// Container App Environment
resource containerAppEnvironment 'Microsoft.App/managedEnvironments@2023-11-02-preview' = {
  name: '${name}-env'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspaceId
        sharedKey: logAnalyticsWorkspaceKey
      }
    }
  }
}

// Container App - runs a simple ASP.NET sample
resource containerApp 'Microsoft.App/containerApps@2023-11-02-preview' = {
  name: name
  location: location
  properties: {
    managedEnvironmentId: containerAppEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        transport: 'auto'
      }
      registries: []
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/dotnet/samples:aspnetapp'
          name: 'web-app'
          resources: {
            cpu: '0.25'
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

output containerAppId string = containerApp.id
output containerAppName string = containerApp.name
output containerAppUrl string = containerApp.properties.configuration.ingress.fqdn

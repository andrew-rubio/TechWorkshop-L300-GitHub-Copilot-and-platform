// Main Bicep file to orchestrate security infrastructure
param location string = resourceGroup().location
param storageAccountName string
param keyVaultName string
param logicAppName string
param acrName string
param containerAppName string
param logAnalyticsName string

module storage 'storage.bicep' = {
  name: 'storageModule'
  params: {
    name: storageAccountName
    location: location
  }
}

module keyvault 'keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    name: keyVaultName
    location: location
  }
}

module logicapp 'logicapp.bicep' = {
  name: 'logicAppModule'
  params: {
    name: logicAppName
    location: location
  }
}

module logAnalytics 'logAnalytics.bicep' = {
  name: 'logAnalyticsModule'
  params: {
    name: logAnalyticsName
    location: location
  }
}

module containerApp 'containerApp.bicep' = {
  name: 'containerAppModule'
  params: {
    name: containerAppName
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.logAnalyticsWorkspaceId
    logAnalyticsWorkspaceKey: logAnalytics.outputs.logAnalyticsWorkspaceKey
    acrName: acrName
    acrUsername: acr.outputs.acrUsername
    acrPassword: acr.outputs.acrPassword
  }
  dependsOn: [
    logAnalytics
  ]
}

module acr 'acr.bicep' = {
  name: 'acrModule'
  params: {
    name: acrName
    location: location
  }
}

// Azure Monitor and Security Center are enabled at the subscription level, not as deployable resources here.

output storageAccountId string = storage.outputs.storageAccountId
output keyVaultId string = keyvault.outputs.keyVaultId
output logicAppId string = logicapp.outputs.logicAppId
output acrId string = acr.outputs.acrId
output containerAppId string = containerApp.outputs.containerAppId
output containerAppUrl string = containerApp.outputs.containerAppUrl
output logAnalyticsId string = logAnalytics.outputs.logAnalyticsId

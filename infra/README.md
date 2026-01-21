# Infrastructure as Code (IaC) for Security and App Platform

This folder contains Bicep templates to deploy Azure resources for security and application hosting:

## Modules
- `main.bicep`: Orchestrates all modules
- `storage.bicep`: Azure Storage Account for documentation
- `keyvault.bicep`: Azure Key Vault for secrets
- `logicapp.bicep`: Logic App for incident intake
- `acr.bicep`: Azure Container Registry
- `logAnalytics.bicep`: Log Analytics Workspace
- `appService.bicep`: Azure App Service

## Usage
1. Update `main.parameters.json` with your values.
2. Deploy with Azure CLI:
   ```sh
   az deployment group create --resource-group <your-rg> --template-file main.bicep --parameters @main.parameters.json
   ```

## Prerequisites
- Azure CLI
- Resource group created

## Notes
- Adjust access policies and triggers as needed for your environment.

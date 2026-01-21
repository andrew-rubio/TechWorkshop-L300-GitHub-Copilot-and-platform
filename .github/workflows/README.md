# GitHub Actions - Build and Deploy Workflow

## Configuration

The `build-deploy.yml` workflow builds your dotnet application as a Docker container and deploys it to your Azure Container App.

## Setup Instructions

### Step 1: Create Azure Service Principal

Run the following command in Azure CLI to create a service principal with Contributor access:

```bash
az ad sp create-for-rbac --name "github-actions" --role Contributor \
  --scopes /subscriptions/13542606-8c93-4e3a-862a-e9c4906c5bdc
```

This will output JSON with `clientId`, `clientSecret`, `subscriptionId`, and `tenantId`.

### Step 2: Add GitHub Secret (AZURE_CREDENTIALS)

1. Go to your GitHub repository
2. Navigate to **Settings > Secrets and variables > Actions**
3. Click **New repository secret**
4. Create a secret named `AZURE_CREDENTIALS` with the entire JSON output from Step 1:

```json
{
  "clientId": "<your-client-id>",
  "clientSecret": "<your-client-secret>",
  "subscriptionId": "13542606-8c93-4e3a-862a-e9c4906c5bdc",
  "tenantId": "<your-tenant-id>"
}
```

### Step 3: Add GitHub Variables

1. In the same **Settings > Secrets and variables > Actions** page, click **Variables** tab
2. Create the following repository variables:

| Variable | Value | Example |
|----------|-------|---------|
| `ACR_NAME` | Your Container Registry name (without `.azurecr.io`) | `zavasecurityacr` |
| `ACR_URL` | Full Container Registry URL | `zavasecurityacr.azurecr.io` |
| `CONTAINER_APP_NAME` | Your Container App name | `zavasecurityapp` |
| `RESOURCE_GROUP` | Your Azure resource group name | `ghcpazuredemo` |

**To find these values**, run:

```bash
# Get Container Registry name
az acr list --query "[].name" -o tsv

# Get Container App name
az containerapp list --resource-group ghcpazuredemo --query "[].name" -o tsv
```

### Step 4: Create Dockerfile

Create a `src/Dockerfile` in your repository:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ZavaStorefront.csproj", "."]
RUN dotnet restore "ZavaStorefront.csproj"
COPY . .
RUN dotnet build "ZavaStorefront.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ZavaStorefront.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ZavaStorefront.dll"]
```

## Triggering Deployments

The workflow runs automatically when you:

- Push changes to the `main` branch in the `src/` folder
- Manually trigger via **Actions > Build and Deploy > Run workflow**

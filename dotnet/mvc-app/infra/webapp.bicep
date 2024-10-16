param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param sku string = 'B1' // The SKU of App Service Plan
param location string = resourceGroup().location
param appEnv string = 'Development'
param imageUrl string = ''

var appServicePlanName = toLower('asp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'app'
}
resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  kind:  'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${imageUrl}' //  'DOTNETCORE|8.0'
      http20Enabled: true
      use32BitWorkerProcess: false
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: appEnv
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}

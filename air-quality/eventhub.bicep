param location string
param eventhubNamespaceName string
param eventhubNamespaceSkuName string
param eventhubName string
param userAssignedIdentityName string

resource eventhubnamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  location: location
  name: eventhubNamespaceName
  sku: {
    capacity: 1
    name: eventhubNamespaceSkuName
  }
  properties: {
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
  }
}

resource eventhub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = {
  parent: eventhubnamespace
  name: eventhubName
  properties: {
    partitionCount: 1
    retentionDescription: {
      cleanupPolicy: 'Delete'
      retentionTimeInHours: 1
    }
  }
}

resource roleassignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: eventhubnamespace
  name: guid(eventhubnamespace.id, userassignedidentity.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    principalId: userassignedidentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalType: 'ServicePrincipal'
  }
}

resource roleassignment2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: eventhubnamespace
  name: guid(eventhubnamespace.id, userassignedidentity.id, 'f526a384-b230-433a-b45c-95f59c4a2dec')
  properties: {
    principalId: userassignedidentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f526a384-b230-433a-b45c-95f59c4a2dec')
    principalType: 'ServicePrincipal'
  }
}

resource userassignedidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userAssignedIdentityName
}

output eventhubnamespaceId string = eventhubnamespace.id

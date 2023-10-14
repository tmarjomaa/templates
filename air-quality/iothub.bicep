param location string
param iothubName string
param iothubSkuName string
param eventhubName string
param routingEndpointEventHubName string
param eventhubNamespaceName string
param userAssignedIdentityName string

resource iothub 'Microsoft.Devices/IotHubs@2022-04-30-preview' = {
  location: location
  name: iothubName
  sku: {
    name: iothubSkuName
    capacity: 1
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities',userAssignedIdentityName)}': {
      } 
    }
  }
  properties: {
    rootCertificate: {
      enableRootCertificateV2: true
    }
    routing: {
      endpoints: {
        eventHubs: [
          {
            name: routingEndpointEventHubName
            authenticationType: 'identityBased'
            endpointUri: 'sb://${eventhubNamespaceName}.servicebus.windows.net'
            entityPath: eventhubName
            identity: {
              userAssignedIdentity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities',userAssignedIdentityName)
            }
            subscriptionId: subscription().subscriptionId
            resourceGroup: resourceGroup().name
          }
        ]
      }
      routes: [
        {
          name: 'eventhub-route'
          endpointNames: [
            routingEndpointEventHubName
          ]
          isEnabled: true
          source: 'DeviceMessages'
          condition: 'true'
        }
      ]
    }
  }  
}

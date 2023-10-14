param location string
param iothubName string
param iothubSkuName string
param eventhubNamespaceName string
param eventhubNamespaceSkuName string
param eventhubName string
param routingEndpointEventHubName string
param userAssignedIdentityName string

module iothub 'iothub.bicep' = {
  name: 'iothub-deploy'
  params: {
    location: location
    iothubName: iothubName
    iothubSkuName: iothubSkuName
    userAssignedIdentityName: userAssignedIdentityName
    eventhubName: eventhubName
    eventhubNamespaceName: eventhubNamespaceName
    routingEndpointEventHubName: routingEndpointEventHubName
  }
  dependsOn: [
    eventhub
    identity
  ]
}

module eventhub 'eventhub.bicep' = {
  name: 'eventhub-deploy'
  params: {
    location: location
    eventhubNamespaceName: eventhubNamespaceName
    eventhubNamespaceSkuName: eventhubNamespaceSkuName
    eventhubName: eventhubName
    userAssignedIdentityName: userAssignedIdentityName
  }
  dependsOn: [
    identity
  ]
}

module identity 'identity.bicep' = {
  name: 'identity-deploy'
  params: {
    location: location
    userAssignedIdentityName: userAssignedIdentityName
  }
}

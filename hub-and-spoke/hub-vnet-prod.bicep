param vnetName string
param location string
param vnetAddressSpace string
param gatewaySubnetAddressPrefix string
param sharedServicesSubnetAddressPrefix string
param azureBastionSubnetAddressPrefix string

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    enableDdosProtection: false
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: gatewaySubnetAddressPrefix
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'SharedServicesSubnet'
        properties: {
          addressPrefix: sharedServicesSubnetAddressPrefix
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: azureBastionSubnetAddressPrefix
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
  }
}

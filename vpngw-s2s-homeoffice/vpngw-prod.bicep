param location string
param vpnGatewayName string
param hubVnetName string
param publicIpName string
param publicIpDNSLabel string
param homeOfficeLgwName string
param homeOfficeAddressSpace string
param homeOfficePublicIpAddress string
param homeOfficeConnectionName string
@secure()
param sharedKey string

resource hubvnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: hubVnetName
}

resource vpngwSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name : 'GatewaySubnet'
  parent: hubvnet
}

resource vpngwpip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    deleteOption: 'Delete'
    dnsSettings: {
      domainNameLabel: publicIpDNSLabel
      fqdn: '${publicIpDNSLabel}.${location}.cloudapp.azure.com'
      reverseFqdn: '${publicIpDNSLabel}.${location}.cloudapp.azure.com'
    }
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
  }
}

resource vpngw 'Microsoft.Network/virtualNetworkGateways@2022-07-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    activeActive: false
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
    disableIPSecReplayProtection: false
    enableBgp: false
    enableBgpRouteTranslationForNat: false
    enablePrivateIpAddress: false
    gatewayType: 'Vpn'
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vpngwpip.id
          }
          subnet: {
            id: vpngwSubnet.id
          }
        }
      }
    ]
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    vpnGatewayGeneration: 'Generation1'
    vpnType: 'RouteBased'
  }
}

resource homeofficelgw 'Microsoft.Network/localNetworkGateways@2022-07-01' = {
  name: homeOfficeLgwName
  location: location
  properties: {
    gatewayIpAddress: homeOfficePublicIpAddress
    localNetworkAddressSpace: {
      addressPrefixes: [
        homeOfficeAddressSpace
      ]
    }
  }
}

resource homeofficeconnection 'Microsoft.Network/connections@2022-07-01' = {
  name: homeOfficeConnectionName
  location: location
  properties: {
    virtualNetworkGateway1: {
      id: vpngw.id
      properties: {
      }
    }
    localNetworkGateway2: {
      id: homeofficelgw.id
      properties: {
      }
    }
    connectionProtocol: 'IKEv2'
    connectionType: 'IPsec'
    connectionMode: 'Default'
    dpdTimeoutSeconds: 0
    enableBgp: false
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    routingWeight: 0
    sharedKey: sharedKey
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
  }
}

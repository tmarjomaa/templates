using './hub-vnet-prod.bicep'

param location = 'westeurope'
param vnetName = 'hub-vnet-prod'
param vnetAddressSpace = '10.112.0.0/23'
param gatewaySubnetAddressPrefix = '10.112.0.0/27'
param sharedServicesSubnetAddressPrefix = '10.112.0.32/27'
param azureBastionSubnetAddressPrefix = '10.112.1.0/26'

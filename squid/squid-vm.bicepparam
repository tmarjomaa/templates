using './squid-vm.bicep'

param location = 'uksouth'
param vmName = 'vm-squid'
param vmSize = 'Standard_B1ms'
param adminUsername = 'b4cloudadmin'
param publicIpDNSLabel = 'building4cloud-squid-test'
param sourceAddressPrefix = ''

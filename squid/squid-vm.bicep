param location string
param vmName string
param vmSize string
param adminUsername string
param publicIpDNSLabel string
param sourceAddressPrefix string

resource vmpip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: '${vmName}-pip'
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

resource vmnic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: '${vmName}-nic1'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vmpip.id
          }
          subnet: {
            id: squidvnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: 'squid-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-ssh'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: sourceAddressPrefix
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'allow-proxy'
        properties: {
          priority: 1100
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3128'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: sourceAddressPrefix
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource squidvnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'squid-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/26'
      ]
    }
    subnets: [
      {
        name: 'SquidSubnet'
        properties: {
          addressPrefix: '10.0.0.0/26'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource squidvm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: vmName
  location: location
  properties: {
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
    hardwareProfile: {
      vmSize: vmSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmnic.id
          properties: {
            deleteOption: 'Delete'
            primary: true
          }
        }
      ]
    }
    osProfile: {
      adminUsername: adminUsername
      allowExtensionOperations: true
      computerName: vmName
      customData: 'IyEvYmluL3NoDQphcHQgdXBkYXRlICYmIGFwdCB1cGdyYWRlIC15ICYmIGFwdCBpbnN0YWxsIC15IHNxdWlkDQoNCmNhdCA8PEVPRiB8IHRlZSAvZXRjL3NxdWlkL3NxdWlkLmNvbmYNCmh0dHBfcG9ydCAzMTI4DQphY2wgU1NMX3BvcnRzIHBvcnQgNDQzDQphY2wgU2FmZV9wb3J0cyBwb3J0IDgwDQphY2wgU2FmZV9wb3J0cyBwb3J0IDIxDQphY2wgU2FmZV9wb3J0cyBwb3J0IDQ0Mw0KYWNsIFNhZmVfcG9ydHMgcG9ydCA3MA0KYWNsIFNhZmVfcG9ydHMgcG9ydCAyMTANCmFjbCBTYWZlX3BvcnRzIHBvcnQgMTAyNS02NTUzNQ0KYWNsIFNhZmVfcG9ydHMgcG9ydCAyODANCmFjbCBTYWZlX3BvcnRzIHBvcnQgNDg4DQphY2wgU2FmZV9wb3J0cyBwb3J0IDU5MQ0KYWNsIFNhZmVfcG9ydHMgcG9ydCA3NzcNCmFjbCBDT05ORUNUIG1ldGhvZCBDT05ORUNUDQpodHRwX2FjY2VzcyBkZW55ICFTYWZlX3BvcnRzDQpodHRwX2FjY2VzcyBkZW55IENPTk5FQ1QgIVNTTF9wb3J0cw0KaHR0cF9hY2Nlc3MgYWxsb3cgbG9jYWxob3N0IG1hbmFnZXINCmh0dHBfYWNjZXNzIGRlbnkgbWFuYWdlcg0KaW5jbHVkZSAvZXRjL3NxdWlkL2NvbmYuZC8qDQpodHRwX2FjY2VzcyBhbGxvdyBhbGwNCmNvcmVkdW1wX2RpciAvdmFyL3Nwb29sL3NxdWlkDQpyZWZyZXNoX3BhdHRlcm4gXmZ0cDogICAgICAgICAgIDE0NDAgICAgMjAlICAgICAxMDA4MA0KcmVmcmVzaF9wYXR0ZXJuIF5nb3BoZXI6ICAgICAgICAxNDQwICAgIDAlICAgICAgMTQ0MA0KcmVmcmVzaF9wYXR0ZXJuIC1pICgvY2dpLWJpbi98XD8pIDAgICAgIDAlICAgICAgMA0KcmVmcmVzaF9wYXR0ZXJuIFwvKFBhY2thZ2VzfFNvdXJjZXMpKHxcLmJ6MnxcLmd6fFwueHopJCAwIDAlIDAgcmVmcmVzaC1pbXMNCnJlZnJlc2hfcGF0dGVybiBcL1JlbGVhc2UofFwuZ3BnKSQgMCAwJSAwIHJlZnJlc2gtaW1zDQpyZWZyZXNoX3BhdHRlcm4gXC9JblJlbGVhc2UkIDAgMCUgMCByZWZyZXNoLWltcw0KcmVmcmVzaF9wYXR0ZXJuIFwvKFRyYW5zbGF0aW9uLS4qKSh8XC5iejJ8XC5nenxcLnh6KSQgMCAwJSAwIHJlZnJlc2gtaW1zDQpFT0YNCg0Kc3lzdGVtY3RsIHJlbG9hZCBzcXVpZA0Kc3lzdGVtY3RsIGVuYWJsZSBzcXVpZA0K'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
        ssh: {
          publicKeys: [
            {
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGJWjH8bzkPog+Fa40oAvsLirN\r\nmfR+DAEWkTRNkfzqstFaFLrC6wwbIV1klBdFECr7DL6CoWBtz9N/9o2ie/GNa+Fj\r\nIq98tWfp9FzgsO2ZW/OHmo64VVsDazmGmdVJX5qeKiW+2qAVn52RI0UWXiwX+dHi\r\nge8cy6oShfxn7yzCWgNxVtZTfOh7jp9A/d3+DoGBWbuQzcPr9CefLvDF9WUjd8AI\r\nqAKsaxE1XOrCkrqAncji4ThgNIbifQNN8nNGuaZ92Vmq7TfvgmxBchX4F3as2L2O\r\n2K0Bzj/Q1MrNGBGFXWQ22POLaH7RmTa52DjUxgVGmINVECc6/lpJGJ4lS3OYOiNq\r\n5OQKnvhomhB2MGBu4+tZF4EA38nHvMJHhhYrfyfYG4bnKVR/k9erguK6hm+W/aGZ\r\nOM01ieVTFWlYBF3HdSD/pZWkrdxxwUvZe+Egd6VZxQ1pcMjTT4PtfwJKLVoeo6X6\r\nzBA0LXm+c/P6Q4ML1F2T2MjiUxHq7cpvsTTmM20= generated-by-azure\r\n'
              path: '/home/${adminUsername}/.ssh/authorized_keys'
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        offer: '0001-com-ubuntu-server-focal'
        publisher: 'canonical'
        sku: '20_04-lts'
        version: 'latest'
      }
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        diskSizeGB: 30
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        name: '${vmName}-disk1'
        osType: 'Linux'
      }
    }
  }
}

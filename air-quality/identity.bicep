param userAssignedIdentityName string
param location string

resource userassignedidentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userAssignedIdentityName
  location: location
}

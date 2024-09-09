param databaseAccountName string
@description('マネージドID のオブジェクト(プリンシパル)ID')
param principalId string
param roleDefinitionId string //= '00000000-0000-0000-0000-000000000002' // 今回はCosmos DB 組み込みデータ共同作成者
param scope string

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: databaseAccountName
}

resource roleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-05-15' = {
  name: guid(principalId, roleDefinitionId, resourceGroup().id)
  parent: databaseAccount
  properties: {
    principalId: principalId
    roleDefinitionId: resourceId('/Microsoft.DocumentDB/databaseAccounts', databaseAccount.name,'sqlRoleDefinitions', roleDefinitionId)
    //roleDefinitionId: resourceId(subscription().id, resourceGroup().name, '/providers/Microsoft.DocumentDB/databaseAccounts', databaseAccountName, 'sqlRoleDefinitions',roleDefinitionId)
    scope: scope
  }
}

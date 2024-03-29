@description('The name of the Logic App')
param logicAppName string

@description('The location to deploy the Logic App')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Resource ID of the log analytics connector')
param logAnalyticsConnectorId string

@description('Logic App version')
param version string

@description('Tags to apply to Logic App')
param tags object

resource logicAppName_resource 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {
        For_each: {
          actions: {
            Condition_2: {
              actions: {
                HTTP_2: {
                  inputs: {
                    authentication: {
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://management.azure.com/subscriptions/@{items(\'For_each\')?[\'subscriptionId\']}/providers/Microsoft.Security/secureScores/ascScore?api-version=2020-01-01-preview'
                  }
                  runAfter: {}
                  type: 'Http'
                }
                HTTP_3: {
                  inputs: {
                    authentication: {
                      type: 'ManagedServiceIdentity'
                    }
                    method: 'GET'
                    uri: 'https://management.azure.com/subscriptions/@{items(\'For_each\')?[\'subscriptionId\']}/providers/Microsoft.Security/secureScores/ascScore/SecureScoreControls?api-version=2020-01-01-preview&$expand=definition'
                  }
                  runAfter: {
                    Send_Data: [
                      'Succeeded'
                    ]
                  }
                  type: 'Http'
                }
                Send_Data: {
                  inputs: {
                    body: '@{body(\'HTTP_2\')}'
                    headers: {
                      'Log-Type': 'SecureScore'
                    }
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'azureloganalyticsdatacollector\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    path: '/api/logs'
                  }
                  runAfter: {
                    HTTP_2: [
                      'Succeeded'
                    ]
                  }
                  type: 'ApiConnection'
                }
                Send_Data_2: {
                  inputs: {
                    body: '@{body(\'HTTP_3\')?[\'value\']}'
                    headers: {
                      'Log-Type': 'SecureScoreControls'
                    }
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'azureloganalyticsdatacollector\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    path: '/api/logs'
                  }
                  runAfter: {
                    HTTP_3: [
                      'Succeeded'
                    ]
                  }
                  type: 'ApiConnection'
                }
                Set_variable: {
                  inputs: {
                    name: 'SecureScoreAssesmentsUri'
                    value: 'https://management.azure.com/subscriptions/@{items(\'For_each\')?[\'subscriptionId\']}/providers/Microsoft.Security/assessments?api-version=2020-01-01&$expand=metadata'
                  }
                  runAfter: {
                    Send_Data_2: [
                      'Succeeded'
                    ]
                  }
                  type: 'SetVariable'
                }
                Until: {
                  actions: {
                    Condition: {
                      actions: {
                        Set_variable_2: {
                          inputs: {
                            name: 'SecureScoreAssesmentsUri'
                            value: '@body(\'Parse_JSON_2\')?[\'nextLink\']'
                          }
                          runAfter: {}
                          type: 'SetVariable'
                        }
                      }
                      else: {
                        actions: {
                          Set_variable_3: {
                            inputs: {
                              name: 'NextPage'
                              value: '@false'
                            }
                            runAfter: {}
                            type: 'SetVariable'
                          }
                        }
                      }
                      expression: {
                        and: [
                          {
                            not: {
                              equals: [
                                '@body(\'Parse_JSON_2\')?[\'nextLink\']'
                                '@null'
                              ]
                            }
                          }
                        ]
                      }
                      runAfter: {
                        Parse_JSON_2: [
                          'Succeeded'
                        ]
                      }
                      type: 'If'
                    }
                    HTTP_4: {
                      inputs: {
                        authentication: {
                          type: 'ManagedServiceIdentity'
                        }
                        method: 'GET'
                        uri: '@variables(\'SecureScoreAssesmentsUri\')'
                      }
                      runAfter: {}
                      type: 'Http'
                    }
                    Parse_JSON_2: {
                      inputs: {
                        content: '@body(\'HTTP_4\')'
                        schema: {
                          properties: {
                            nextLink: {
                              type: 'string'
                            }
                            value: {
                              items: {
                                properties: {
                                  id: {
                                    type: 'string'
                                  }
                                  name: {
                                    type: 'string'
                                  }
                                  properties: {
                                    properties: {
                                      displayName: {
                                        type: 'string'
                                      }
                                      resourceDetails: {
                                        properties: {
                                          Id: {
                                            type: 'string'
                                          }
                                          Source: {
                                            type: 'string'
                                          }
                                        }
                                        type: 'object'
                                      }
                                      status: {
                                        properties: {
                                          code: {
                                            type: 'string'
                                          }
                                        }
                                        type: 'object'
                                      }
                                    }
                                    type: 'object'
                                  }
                                  type: {
                                    type: 'string'
                                  }
                                }
                                required: [
                                  'type'
                                  'id'
                                  'name'
                                  'properties'
                                ]
                                type: 'object'
                              }
                              type: 'array'
                            }
                          }
                          type: 'object'
                        }
                      }
                      runAfter: {
                        Send_Data_3: [
                          'Succeeded'
                        ]
                      }
                      type: 'ParseJson'
                    }
                    Send_Data_3: {
                      inputs: {
                        body: '@{body(\'HTTP_4\')?[\'value\']}'
                        headers: {
                          'Log-Type': 'SecureScoreAssesments'
                        }
                        host: {
                          connection: {
                            name: '@parameters(\'$connections\')[\'azureloganalyticsdatacollector\'][\'connectionId\']'
                          }
                        }
                        method: 'post'
                        path: '/api/logs'
                      }
                      runAfter: {
                        HTTP_4: [
                          'Succeeded'
                        ]
                      }
                      type: 'ApiConnection'
                    }
                  }
                  expression: '@equals(variables(\'NextPage\'), false)'
                  limit: {
                    count: 10
                    timeout: 'PT1H'
                  }
                  runAfter: {
                    Set_variable: [
                      'Succeeded'
                    ]
                  }
                  type: 'Until'
                }
              }
              expression: {
                and: [
                  {
                    equals: [
                      '@body(\'Parse_JSON_3\')?[\'registrationState\']'
                      'Registered'
                    ]
                  }
                  {
                    equals: [
                      '@items(\'For_each\')?[\'state\']'
                      'Enabled'
                    ]
                  }
                ]
              }
              runAfter: {
                Parse_JSON_3: [
                  'Succeeded'
                ]
              }
              type: 'If'
            }
            HTTP_5: {
              inputs: {
                authentication: {
                  type: 'ManagedServiceIdentity'
                }
                method: 'GET'
                uri: 'https://management.azure.com/subscriptions/@{items(\'For_each\')?[\'subscriptionId\']}/providers/Microsoft.Security?api-version=2019-10-01'
              }
              runAfter: {}
              type: 'Http'
            }
            Parse_JSON_3: {
              inputs: {
                content: '@body(\'HTTP_5\')'
                schema: {
                  properties: {
                    id: {
                      type: 'string'
                    }
                    namespace: {
                      type: 'string'
                    }
                    registrationPolicy: {
                      type: 'string'
                    }
                    registrationState: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
              }
              runAfter: {
                HTTP_5: [
                  'Succeeded'
                ]
              }
              type: 'ParseJson'
            }
          }
          foreach: '@body(\'Parse_JSON\')?[\'value\']'
          runAfter: {
            Parse_JSON: [
              'Succeeded'
            ]
          }
          runtimeConfiguration: {
            concurrency: {
              repetitions: 1
            }
          }
          type: 'Foreach'
        }
        HTTP: {
          inputs: {
            authentication: {
              type: 'ManagedServiceIdentity'
            }
            method: 'GET'
            uri: 'https://management.azure.com/subscriptions?api-version=2020-01-01'
          }
          runAfter: {
            Initialize_variable_3: [
              'Succeeded'
            ]
          }
          type: 'Http'
        }
        Initialize_variable: {
          inputs: {
            variables: [
              {
                name: 'NextPage'
                type: 'boolean'
                value: '@true'
              }
            ]
          }
          runAfter: {}
          type: 'InitializeVariable'
        }
        Initialize_variable_2: {
          inputs: {
            variables: [
              {
                name: 'SecureScoreAssesmentsUri'
                type: 'string'
              }
            ]
          }
          runAfter: {
            Initialize_variable: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Initialize_variable_3: {
          inputs: {
            variables: [
              {
                name: 'test'
                type: 'string'
              }
            ]
          }
          runAfter: {
            Initialize_variable_2: [
              'Succeeded'
            ]
          }
          type: 'InitializeVariable'
        }
        Parse_JSON: {
          inputs: {
            content: '@body(\'HTTP\')'
            schema: {
              properties: {
                count: {
                  properties: {
                    type: {
                      type: 'string'
                    }
                    value: {
                      type: 'integer'
                    }
                  }
                  type: 'object'
                }
                value: {
                  items: {
                    properties: {
                      authorizationSource: {
                        type: 'string'
                      }
                      displayName: {
                        type: 'string'
                      }
                      id: {
                        type: 'string'
                      }
                      state: {
                        type: 'string'
                      }
                      subscriptionId: {
                        type: 'string'
                      }
                      subscriptionPolicies: {
                        properties: {
                          locationPlacementId: {
                            type: 'string'
                          }
                          quotaId: {
                            type: 'string'
                          }
                          spendingLimit: {
                            type: 'string'
                          }
                        }
                        type: 'object'
                      }
                      tenantId: {
                        type: 'string'
                      }
                    }
                    required: [
                      'id'
                      'authorizationSource'
                      'subscriptionId'
                      'tenantId'
                      'displayName'
                      'state'
                      'subscriptionPolicies'
                    ]
                    type: 'object'
                  }
                  type: 'array'
                }
              }
              type: 'object'
            }
          }
          runAfter: {
            Send_Data_4: [
              'Succeeded'
            ]
          }
          type: 'ParseJson'
        }
        Send_Data_4: {
          inputs: {
            body: '@{body(\'HTTP\')?[\'value\']}'
            headers: {
              'Log-Type': 'Subscriptions'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azureloganalyticsdatacollector\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/api/logs'
          }
          runAfter: {
            HTTP: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
        }
      }
      contentVersion: version
      outputs: {}
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Day'
            interval: 1
          }
          type: 'Recurrence'
        }
      }
    }
    parameters: {
      '$connections': {
        value: {
          azureloganalyticsdatacollector: {
            connectionId: logAnalyticsConnectorId
            id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${resourceGroup().location}/managedApis/azureloganalyticsdatacollector'
          }
        }
      }
    }
  }
}
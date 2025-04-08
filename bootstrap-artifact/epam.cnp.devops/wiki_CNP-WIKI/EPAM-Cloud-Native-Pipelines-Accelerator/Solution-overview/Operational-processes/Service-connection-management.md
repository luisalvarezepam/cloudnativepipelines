[[_TOC_]]

## Solution description

This solution provides the possibility of automation service connections management. It is possible to create new and delete existed service connections. For creation of a new service connection this solution uses the configuration in JSON format.
The following service connection types are supported:

- [Azure Resource Manager (subscription scope)](#azure-resource-manager-(subscription-scope)-service-connection-configuration)
- [Docker Registry (Azure Container Registry)](#docker-registry-(azure-container-registry)-service-connection-configuration)
- [Kubernetes (authentication method is kubeconfig)](#kubernetes-(authentication-method-is-kubeconfig)-service-connection-configuration)

The solution includes the pipeline and the configuration files in JSON format.

:warning: **_NOTE:_** It is important to use right permissions for Service Principals which are used for connecting to Azure Cloud and for person who creates the PAT tokens, because you need different kinds of permissions to manage different types of service connections. [More information you could see here.](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)

## Automation service connection managing pipeline

The pipeline uses variables declared in the variable group (groups) and input parameters to get needed data from the Azure Cloud and to declare internal pipeline variables. 
The pipeline replaces tokenized values in the configuration files with variable values declared in the variable group (groups) or during pipeline execution and creates service connections using modified configuration files.

### Pipeline input parameters

| **Parameter name** | **Type** | **Description** | **Example value** |
|--------------------|----------|-----------------|-------------------|
| workingDirectory | string | The full path to the folder where configuration files exist | example/service_connections/configurations |
| scType | string | The type of the service connection | Possible values are: `subscription`, `acr`, `aks` |
| scName | string | The name of the service connection | example_service_connection |
| scDelete | boolean | Is it needed to delete the service connection? | Default value is `false` |
| ClusterContext | string | The kubernetes cluster context name in the kubernetes configuration file | Default value is `current-context` |
| grantAccess | boolean | Is it needed to grant access to the all pipelines? | Default value is `false` |
| patToken | string | The value of the PAT token to access Azure DevOps organization. This PAT token should have following permissions: **Build** - Read & execute; **Service Connections** - Read, query, & manage | - |

### Pipeline input variables

| **Variable name** | **Type** | **Description** |
|-------------------|----------|-----------------|
| ENV_AZURE_CLIENT_ID | string | The ID of the service principle which is used to connect to the subscription |
| ENV_AZURE_CLIENT_SECRET | secret string | The secret of the service principle which is used to connect to the subscription |
| ENV_AZURE_TENANT_ID | string | The ID of the tenant (Azure organization) where the subscription exists |
| ENV_AZURE_SUBSCRIPTION_ID | string | The ID of the subscription to which service connection should be created. Or the ID of the subscription where the resources to which service connection should be created exist |
| ENV_AKS_RG | string | The resource group name where kubernetes cluster was created |

## Azure Resource Manager (subscription scope) service connection configuration

This is a configuration file in JSON format for creating service connection to Azure Resource Manager on the subscription level. 

### Environment variables for Azure Resource Manager (subscription scope) service connection

These variables should exist in the variable group in the Azure DevOps pipelines

| **Variable name** | **Type** | **Description** |
|-------------------|----------|-----------------|
| ENV_AZURE_SUBSCRIPTION_ID | string | The ID of the subscription to which service connection should be created |
| ENV_AZURE_CLIENT_ID | string | The ID of the service principle which is used to connect to the subscription |
| ENV_AZURE_CLIENT_SECRET | secret string | The secret of the service principle which is used to connect to the subscription |
| ENV_AZURE_TENANT_ID | string | The ID of the tenant (Azure organization) where the subscription exists |

### Pipeline variables for Azure Resource Manager (subscription scope) service connection

These variables are declared automatically during pipeline execution

| **Variable name** | **Type** | **Description** |
|-------------------|----------|-----------------|
| PIPE_AZURE_SUBSCRIPTION_NAME | string | The name of the subscription to which service connection should be created |
| PIPE_SERVICE_ENDPOINT | string | The name of the service connection. This variable gets the value from the `scName` pipeline input parameter |

### Azure Resource Manager (subscription scope) service connection configuration example

```go
{
    "data": {
        "environment": "AzureCloud",
        "scopeLevel": "Subscription",
        "subscriptionId": "#{ENV_AZURE_SUBSCRIPTION_ID}#",
        "subscriptionName": "#{PIPE_AZURE_SUBSCRIPTION_NAME}#"
    },
    "name": "#{PIPE_SERVICE_ENDPOINT}#",
    "type": "azurerm",
    "description": "This Service Connection was created automatically by automation pipeline.",
    "url": "https://management.azure.com/",
    "authorization": {
        "parameters": {
            "authenticationType": "spnKey",
            "serviceprincipalid": "#{ENV_AZURE_CLIENT_ID}#",
            "serviceprincipalkey": "#{ENV_AZURE_CLIENT_SECRET}#",
            "tenantid": "#{ENV_AZURE_TENANT_ID}#"
        },
        "scheme": "ServicePrincipal"
    },
    "authorized": true,
    "isShared": false,
    "isReady": true,
    "serviceEndpointProjectReferences": [
        {
            "projectReference": {
                "id": "#{System.TeamProjectId}#",
                "name": "#{System.TeamProject}#"
            },
            "name": "#{PIPE_SERVICE_ENDPOINT}#"
        }
    ]
}
```

## Docker Registry (Azure Container Registry) service connection configuration

This is a configuration file in JSON format for creating service connection to Azure Container Registry.

### Environment variables for Azure Container Registry service connection

These variables should exist in the variable group in the Azure DevOps pipelines

| **Variable name** | **Type** | **Description** |
|-------------------|----------|-----------------|
| ENV_ACR_NAME | string | The name of the Azure Container Registry to which service connection should be created |
| ENV_ACR_RG_NAME | string | The resource group name where Azure Container Registry has been created |
| ENV_AZURE_SUBSCRIPTION_ID | string | The ID of the subscription where Azure Container Registry has been created |
| ENV_AZURE_CLIENT_ID | string | The ID of the service principle which is used to connect to the subscription |
| ENV_AZURE_CLIENT_SECRET | secret string | The secret of the service principle which is used to connect to the subscription |
| ENV_AZURE_TENANT_ID | string | The ID of the tenant (Azure organization) where the subscription exists |

### Pipeline variables for Azure Container Registry service connection

These variables are declared automatically during pipeline execution

| **Variable name** | **Type** | **Description** |
|-------------------|----------|-----------------|
| PIPE_AZURE_SUBSCRIPTION_NAME | string | The name of the subscription where Azure Container Registry has been created |
| PIPE_SERVICE_ENDPOINT | string | The name of the service connection. This variable gets the value from the `scName` pipeline input parameter |

### Docker Registry (Azure Container Registry) service connection configuration example

```go
{
    "administratorsGroup": null,
    "authorization": {
      "parameters": {
        "loginServer": "#{ENV_ACR_NAME}#.azurecr.io",
        "role": "8311e382-0749-4cb8-b61a-304f252e45ec",
        "scope": "/subscriptions/#{ENV_AZURE_SUBSCRIPTION_ID}#/resourceGroups/#{ENV_ACR_RG_NAME}#/providers/Microsoft.ContainerRegistry/registries/#{ENV_ACR_NAME}#",
        "servicePrincipalId": "#{ENV_AZURE_CLIENT_ID}#",
        "tenantId": "#{ENV_AZURE_TENANT_ID}#"
      },
      "scheme": "ServicePrincipal"
    },
    "data": {
      "registryId": "/subscriptions/#{ENV_AZURE_SUBSCRIPTION_ID}#/resourceGroups/#{ENV_ACR_RG_NAME}#/providers/Microsoft.ContainerRegistry/registries/#{ENV_ACR_NAME}#",
      "registrytype": "ACR",
      "serviceprincipalkey": "#{ENV_AZURE_CLIENT_SECRET}#",
      "authenticationType": "spnKey",
      "subscriptionId": "#{ENV_AZURE_SUBSCRIPTION_ID}#",
      "subscriptionName": "#{PIPE_AZURE_SUBSCRIPTION_NAME}#"
    },
    "description": "This Service Connection was created automatically by automation pipeline.",
    "groupScopeId": null,
    "isReady": true,
    "isShared": false,
    "name": "#{PIPE_SERVICE_ENDPOINT}#",
    "owner": "Library",
    "readersGroup": null,
    "serviceEndpointProjectReferences": [
      {
        "description": "This Service Connection was created automatically by automation pipeline.",
        "name": "#{PIPE_SERVICE_ENDPOINT}#",
        "projectReference": {
          "id": "#{System.TeamProjectId}#",
          "name": "#{System.TeamProject}#"
        }
      }
    ],
    "type": "dockerregistry",
    "url": "https://hub.docker.com/"
  }
  ```

## Kubernetes (authentication method is kubeconfig) service connection configuration

  This is a configuration file in JSON format for creating service connection to Kubernetes cluster using a kubeconfig data.

### Pipeline variables for kubernetes service connection

These variables are declared automatically during pipeline execution

| **Variable name** | **Type** | **Description** |
|-------------------|----------|-----------------|
| PIPE_AKS_URL | string | The URL of the kubernetes cluster. |
| PIPE_AKS_KUBE_CONFIG | string | The data of the kubernetes configuration file formatted to a string |
| PIPE_CLUSTER_CONTEXT | string | The name of the kubernetes cluster context which should be used for service connection. It is based on the `ClusterContext` pipeline input parameter value |
| PIPE_SERVICE_ENDPOINT | string | The name of the service connection. This variable gets the value from the `scName` pipeline input parameter |

### Kubernetes (authentication method is kubeconfig) service connection configuration example

```go
{
    "data": {
        "authorizationType": "Kubeconfig",
        "acceptUntrustedCerts": true
    },
    "name": "#{PIPE_SERVICE_ENDPOINT}#",
    "type": "kubernetes",
    "description": "This Service Connection was created automatically by automation pipeline.",
    "url": "#{PIPE_AKS_URL}#",
    "authorization": {
        "parameters": {
            "kubeConfig": "#{PIPE_AKS_KUBE_CONFIG}#",
            "clusterContext": "#{PIPE_CLUSTER_CONTEXT}#"
        },
        "scheme": "Kubernetes"
    },
    "isShared": false,
    "isReady": true,
    "serviceEndpointProjectReferences": [
        {
            "projectReference": {
                "id": "#{System.TeamProjectId}#",
                "name": "#{System.TeamProject}#"
            },
            "name": "#{PIPE_SERVICE_ENDPOINT}#"
        }
    ]
}
```
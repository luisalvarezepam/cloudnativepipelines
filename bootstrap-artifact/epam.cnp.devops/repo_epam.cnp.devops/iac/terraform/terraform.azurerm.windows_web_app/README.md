# terraform.azurerm.windowswebapp

This module creates a Windows Web Application Service with deployment slots, and connection to Data Base.

## Prerequisites

| Resource name | Required | Description |
|---------------|----------|-------------|
| Resource group        | yes   |        |
| App service plan      | yes   |        |
| Data Base             | no    | for example CosmosDB or MSSQL Server + MSSQL DB     |
| Storage account       | no    | Storage account can be used for backup, logs storing, and application data storing. |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.30.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_windows_web_app.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app) | resource |
| [azurerm_windows_web_app_slot.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app_slot) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_service_plan.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_subnet.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |



## Usage example

```go
module "windowswebapp" {
  source = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.windows_web_app?ref=v1.3.0"

  name              = "example-windowswebapp"
  rg_name           = "example-rg"
  location          = "estus"
  service_plan_name = "example-asp"
  https_only        = false
  zip_deploy_file   = "/home/myfolder/example.zip"
  site_config = {
    always_on                                     = true
    container_registry_use_managed_identity       = false
    container_registry_managed_identity_client_id = null
    ftps_state                                    = "Disabled"
    health_check_path                             = "example/path"
    http2_enabled                                 = true
    load_balancing_mode                           = "LeastRequests"
    local_mysql_enabled                           = false
    minimum_tls_version                           = "1.2"
    remote_debugging_enabled                      = false
    scm_use_main_ip_restriction                   = false
    scm_minimum_tls_version                       = "1.2"
    use_32_bit_worker                             = true
    vnet_route_all_enabled                        = false
    websockets_enabled                            = false
    worker_count                                  = 4
  }

  application_stack = {
    current_stack             = "python"
    docker_container_name     = "azure-app-service/samples/aspnethelloworld"
    docker_container_registry = "mcr.microsoft.com"
    docker_container_tag      = "latests"
    dotnet_version            = "5.0"
    java_container            = "TOMCAT"
    java_container_version    = "1.0"
    java_version              = "11"
    node_version              = "12-LTS"
    php_version               = "7.4"
    python_version            = "2.7"
  }
  virtual_application = [
    {
      physical_path = "/example/physical/path_01"
      preload       = false
      virtual_path  = "/"
      virtual_directory = [
        {
          physical_path = "example/physical/path_01"
          virtual_path  = "/"
        }
      ]
    }
  ]
  auto_heal_setting = {
    auto_heal_enabled = false
    action = {
      action_type                    = "Recycle"
      minimum_process_execution_time = "01:10:10"
    }
    trigger = {
      private_memory_kb = 102400
      requests = {
        count    = 5
        interval = "01:10:10"
      }
      slow_request = {
        count      = 5
        interval   = "02:20:20"
        time_taken = "00:20:00"
        path       = "/example/slow/path"
      }
      status_code = {
        count             = 5
        interval          = "01:10:10"
        status_code_range = "400-499"
        path              = "/example/status_code/path"
        sub_status        = "11"
        win32_status      = "64"
      }
    }
  }
  ip_restriction = [
    {
      action     = "Allow"
      ip_address = "192.168.10.1/32"
      name       = "example_restriction_01"
      priority   = "500"
    },
    {
      action     = "Deny"
      ip_address = "10.0.0.0/24"
      name       = "example_restriction_02"
      priority   = "400"
    }
  ]
  scm_ip_restriction = [
    {
      action     = "Deny"
      ip_address = "10.1.1.0/24"
      name       = "example_restriction_03"
      priority   = "300"
    }
  ]
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = "example-instrumentation-key"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
  }
  backup = {
    name = "example-backup"
    schedule = {
      frequency_interval       = 7
      frequency_unit           = "Day"
      keep_at_least_one_backup = false
      retention_period_days    = 90
      start_time               = "2002-10-02T10:00:00-05:00"
      enabled                  = true
      storage_account_url      = "example/storage/account/url"
    }
  }
  connection_string = [
    {
      name  = "example-connection-string"
      type  = "MySQL"
      value = "connection/string/example/value"
    }
  ]
  identity = {
    type         = "UserAssigned"
    identity_ids = ["example/identity/id"]
  }
  regional_network_integration = {
    subnet_name  = "example-subnet"
    vnet_name    = "example-vnet"
    vnet_rg_name = "example-rg-vnet-01"
  }
  logs = {
    detailed_error_messages = true
    failed_request_tracing  = false
    application_logs = {
      file_system_level = "Verbose"
    }
    http_logs = {
      file_system = {
        retention_in_days = 10
        retention_in_mb   = 500
      }
    }
    azure_blob_storage = {
      level             = "Error"
      retention_in_days = 10
      sas_url           = "example/azure/blob/sas/url"
    }
  }
  storage_account = {
    access_key   = "example-access-key"
    account_name = "examplestorage01"
    name         = "example-name"
    share_name   = "examplecontainer"
    type         = "AzureBlob"
    mount_path   = "/home/example/mount/path"
  }
  sticky_settings = {
    app_setting_names = [
      "example-app-settings01",
      "example-app-settings02"
    ]
    connection_string_names = [
      "example-connection-string01",
      "example-connection-string02"
    ]
  }
  web_app_slots = [
    {
      always_on       = false
      name            = "example-slot-name"
      zip_deploy_file = "/home/myfolder/new_example.zip"
      app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
        "APPINSIGHTS_INSTRUMENTATIONKEY"             = "example-instrumentation-key"
        "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
      }
      application_stack = {
        current_stack             = "python"
        docker_container_name     = "azure-app-service/samples/aspnethelloworld"
        docker_container_registry = "mcr.microsoft.com"
        docker_container_tag      = "latests"
        dotnet_version            = "5.0"
        java_container            = "TOMCAT"
        java_container_version    = "1.0"
        java_version              = "11"
        node_version              = "12-LTS"
        php_version               = "7.4"
        python_version            = "2.7"
      }
      connection_string = [
        {
          name  = "example-connection-string"
          type  = "MySQL"
          value = "connection/string/example/value"
        }
      ]
      virtual_application = [
        {
          physical_path = "/example/physical/path_01"
          preload       = false
          virtual_path  = "/"
          virtual_directory = [
            {
              physical_path = "example/physical/path_01"
              virtual_path  = "/"
            }
          ]
        }
      ]
      tags = {
        Environment  = "Testing"
        Organization = "XYZ"
      }
    }
  ]
  tags = {
    Environment  = "Prodaction"
    Organization = "XYZ"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | A map of key-value pairs of App Settings. | `map(string)` | `{}` | no |
| <a name="input_application_stack"></a> [application\_stack](#input\_application\_stack) | The map that describes application stack settings<br><br>    `current_stack`             - The Application Stack for the Windows Web App. Possible values include `dotnet`, `dotnetcore`, <br>                                  `node`, `python`, `php`, and `java`.<br>                                  Whilst this property is Optional omitting it can cause unexpected behaviour, in particular for display <br>                                  of settings in the Azure Portal.<br>                                  The value of `dotnetcore` is for use in combination with `dotnet_version` set to `core3.1` only.<br>    `docker_container_name`     - The name of the Docker Container. For example `azure-app-service/samples/aspnethelloworld`.<br><br>    `docker_container_registry` - The registry Host on which the specified Docker Container can be located. For example `mcr.microsoft.com`<br><br>    `docker_container_tag`      - The Image Tag of the specified Docker Container to use. For example `latest`.<br><br>    `dotnet_version`            - The version of .NET to use when `current_stack` is set to `dotnet`. Possible values include `v2.0`, `v3.0`, <br>                                  `core3.1`, `v4.0`, `v5.0`, `v6.0` and `v7.0`.<br>    `java_container`            - The Java container type to use when `current_stack` is set to `java`. Possible values include `JAVA, `JETTY`, and `TOMCAT`. <br>                                  Required with `java\_version` and `java\_container\_version`.<br>    `java\_container\_version`    - The Version of the `java\_container` to use. Required with `java\_version` and `java\_container`. <br>                              <br>    `java\_version`              - The version of Java to use when `current\_stack` is set to `java`. Possible values include `1.7`, `1.8`, `11` and `17`. <br>                                  Required with `java\_container` and `java\_container\_version`.<br>                                  For compatible combinations of `java\_version`, `java\_container` and `java\_container\_version` users can use `az webapp list-runtimes` from command line.<br>    `node\_version`              - The version of node to use when `current\_stack` is set to `node`. Possible values include `12-LTS`, `14-LTS`, and `16-LTS`.<br>                                  This property conflicts with `java\_version`.<br>    `php\_version`               - The version of PHP to use when `current\_stack` is set to `php`. Possible values include `v7.4`.<br><br>    `python\_version`            - The version of Python to use when `current\_stack` is set to `python`. Possible values include `2.7` and `3.4.0`.<br><br>` | `map(string)` | `null` | no |
| <a name="input_auto_heal_setting"></a> [auto\_heal\_setting](#input\_auto\_heal\_setting) | The object that describes auto heal settings<br><br>    `auto_heal_enabled` -  Should Auto heal rules be enabled? Required with auto\_heal\_setting.<br><br>    `action`  - The object that describes actions for auto heal<br>        `action_type`                    - Predefined action to be taken to an Auto Heal trigger. Possible values include: `Recycle`, `LogEvent`, and `CustomAction`.<br>        `minimum_process_execution_time` - The minimum amount of time in `hh:mm:ss` the Windows Web App must have been running before the defined action will be run in the event of a trigger.<br><br>    `trigger` - The object that describes trigger for auto heal<br>        `private_memory_kb` -  The amount of Private Memory to be consumed for this rule to trigger. <br>                               Possible values are between `102400` and `13631488`. <br>        `requests`          - The object that describes trigger requests for auto heal.<br>            `count`       - The number of requests in the specified `interval` to trigger this rule.<br>            `interval`    - The interval in `hh:mm:ss`.<br><br>        `slow_request`      - The object that describes trigger slow requests for auto heal.<br>            `count`       - The number of Slow Requests in the time `interval` to trigger this rule.<br>            `interval`    - The time interval in the form `hh:mm:ss`.<br>            `time_taken`  - The threshold of time passed to qualify as a Slow Request in `hh:mm:ss`.<br>            `path`        - The path for which this slow request rule applies.<br><br>        `status_code`       - The object that describe status code settings for auto heal trigger.<br>            `count`             - The number of occurrences of the defined `status_code` in the specified `interval`<br>                                on which to trigger this rule.<br>            `interval`          - The time interval in the form `hh:mm:ss`.<br>            `status_code_range` - The status code for this rule, accepts single status codes and status code ranges. e.g. <br>                                `500` or `400-499`. Possible values are integers between `101` and `599`.<br>            `path`              - The path to which this rule status code applies.<br>            `sub_status`        - The Request Sub Status of the Status Code.<br>            `win32_status`      - The Win32 Status Code of the Request. | <pre>object({<br>    auto_heal_enabled = bool<br>    action = object({<br>      action_type                    = string<br>      minimum_process_execution_time = string<br>      custom_action                  = object({})<br>    })<br>    trigger = object({<br>      private_memory_kb = number<br>      requests = object({<br>        count    = number<br>        interval = string<br>      })<br>      slow_request = object({<br>        count      = number<br>        interval   = string<br>        time_taken = string<br>        path       = string<br>      })<br>      status_code = object({<br>        count             = number<br>        interval          = string<br>        status_code_range = string<br>        path              = string<br>        sub_status        = string<br>        win32_status      = string<br>      })<br>    })<br>  })</pre> | `null` | no |
| <a name="input_backup"></a> [backup](#input\_backup) | The object that describes windows webapp backup settings.<br><br>    `name`               - The name which should be used for this Backup.<br>    `schedule`           - The object that describes backup schedule.<br>        `frequency_interval`       - How often the backup should be executed (e.g. for weekly backup, <br>                                     this should be set to `7` and `frequency_unit` should be set to `Day`).<br>                                     Not all intervals are supported on all Windows Web App SKUs. Please refer <br>                                     to the official documentation for appropriate values.<br>        `frequency_unit`           - The unit of time for how often the backup should take place. Possible values<br>                                     include: `Day`, `Hour`.<br><br>        `keep_at_least_one_backup` - Should the service keep at least one backup, regardless of the age of backup? <br>                                     Defaults to `false`.<br>        `retention_period_days`    - After how many days backups should be deleted.<br><br>        `start_time`               - When the schedule should start working in `RFC-3339` format.<br><br>    `storage_account_url` - The SAS URL to the container.<br><br>    `enabled`             - Should this backup job be enabled? | <pre>object({<br>    name = string<br>    schedule = object({<br>      frequency_interval       = string<br>      frequency_unit           = string<br>      keep_at_least_one_backup = bool<br>      retention_period_days    = number<br>      start_time               = string<br>    })<br>    storage_account_url = string<br>    enabled             = bool<br>  })</pre> | `null` | no |
| <a name="input_connection_string"></a> [connection\_string](#input\_connection\_string) | The list of objects that describe connection string settings.<br><br>    `name`  - The name of the Connection String.<br><br>    `type`  - Type of database. Possible values include: `MySQL`, `SQLServer`, `SQLAzure`, `Custom`, <br>              `NotificationHub`, `ServiceBus`, `EventHub`, `APIHub`, `DocDb`, `RedisCache`, and `PostgreSQL`.<br><br>    `value` - The connection string value. | <pre>list(object({<br>    name  = string<br>    type  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_diagnostic_setting"></a> [diagnostic\_setting](#input\_diagnostic\_setting) | The description of parameters for Diagnistic Setting:<br>    `diagnostic_setting_name` - specifies the name of the Diagnostic Setting;<br>    `log_analytics_workspace_id` - ID of the Log Analytics Workspace;<br>    `storage_account_id` - the ID of the Storage Account where logs should be sent;<br>    `log` - describes logs for Diagnistic Setting: <br>      `category` -  the name of a Diagnostic Log Category for this Resource. list of <br>        available logs: <br>        _AppServicePlatformLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceplatformlogs) ;<br>        _AppServiceIPSecAuditLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceipsecauditlogs));<br>        _AppServiceAuditLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceauditlogs);<br>        _AppServiceConsoleLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceconsolelogs);<br>        _AppServiceHTTPLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appservicehttplogs);<br>        _AppServiceAppLogs_ -[log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceapplogs);<br>      `enabled` -  is this Diagnostic Log enabled?;<br>      `retention_policy` - describes logs retention policy (needed to store data in the Storage Account):<br>        `enabled` - is this Retention Policy enabled?<br>        `days` - the number of days for which this Retention Policy should apply.<br>    `metric` - describes metric for Diagnistic Setting:<br>      `category` -  the name of a Diagnostic Metric Category for this Resource. List of<br>        available Metrics: _AllMetrics_ ;<br>      `enabled` -  is this Diagnostic Metric enabled?<br>      `retention_policy` - describes Metric retention policy (needed to store data in the Storage Account):<br>        `enabled` - is this Retention Policy enabled?;<br>        `days` - the number of days for which this Retention Policy should apply. | `any` | `null` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | Should the Windows Web App require HTTPS connections. | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | The object describes identity settings.<br><br>    `type`         - Specifies the type of Managed Service Identity that should be configured on this Windows Web App. <br>                     Possible values are `SystemAssigned`, and `UserAssigned`, and `SystemAssigned, UserAssigned` (to enable both).<br><br>    `identity_ids` - A list of User Assigned Managed Identity IDs to be assigned to this Windows Web App.<br>                     This is required when type is set to `UserAssigned` or `SystemAssigned, UserAssigned`. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_ip_restriction"></a> [ip\_restriction](#input\_ip\_restriction) | The list of objects that describes ip restrictions for site config.<br><br>    `action`     - The action to take. Possible values are `Allow` or `Deny`.<br><br>    `ip_address` - The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`.<br><br>    `name`       - The name which should be used for this `ip_restriction`.<br><br>    `priority`   - The priority value of this `ip_restriction`. | <pre>list(object({<br>    action     = string<br>    ip_address = string<br>    name       = string<br>    priority   = string<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the Windows Web App should exist. Changing this forces a new Windows Web App to be created.<br>    If the parameter is not specified in the configuration file, the location of the resource group is used. | `string` | `null` | no |
| <a name="input_logs"></a> [logs](#input\_logs) | The object that describes settings for Web App logs.<br><br>    `detailed_error_messages` - Should detailed error messages be enabled?<br><br>    `failed_request_tracing`  - Should the failed request tracing be enabled?<br><br>    `application_logs`        - The object that describes application logs settings.<br>        `file_system_level` - Log level. Possible values include: `Verbose`, `Information`, `Warning`, and `Error`.<br><br>    `http_logs`               - The object that describes https logs settings.<br>        `file_system` - The object that describes file system settings<br>            `retention_in_days` - The retention period in days. A value of 0 means no retention.<br>            `retention_in_mb`   - The maximum size in megabytes that log files can use.<br><br>    `azure_blob_storage`      - The object that describe azure blob settings for Web App logs.<br>        `level`             - The level at which to log. Possible values include `Error`, `Warning`, `Information`, `Verbose` and `Off`.<br>                              This field is not available for `http_logs`.<br>        `retention_in_days` - The time in days after which to remove blobs. A value of `0` means no retention.<br><br>        `sas_url`           - SAS url to an Azure blob container with read/write/list/delete permissions. | <pre>object({<br>    detailed_error_messages = bool<br>    failed_request_tracing  = bool<br>    application_logs = object({<br>      file_system_level = string<br>    })<br>    http_logs = object({<br>      file_system = object({<br>        retention_in_days = number<br>        retention_in_mb   = number<br>      })<br>    })<br>    azure_blob_storage = object({<br>      level             = string<br>      retention_in_days = number<br>      sas_url           = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name which should be used for this Windows Web App. Changing this forces a new Windows Web App to be created. | `string` | n/a | yes |
| <a name="input_regional_network_integration"></a> [regional\_network\_integration](#input\_regional\_network\_integration) | The object that describes subnet for regional network integration for webapp.<br><br>    `subnet_name`  - The subnet name which will be used by this Web App for regional virtual network integration.<br><br>    `vnet_name`    - The VNET name where subnet exists.<br><br>    `vnet_rg_name` - The resource group name where VNET exists. | <pre>object({<br>    subnet_name  = string<br>    vnet_name    = string<br>    vnet_rg_name = string<br>  })</pre> | `null` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the Resource Group where the Windows Web App should exist. Changing this forces a new Windows Web App to be created. | `string` | n/a | yes |
| <a name="input_scm_ip_restriction"></a> [scm\_ip\_restriction](#input\_scm\_ip\_restriction) | The list of objects that describes scm ip restriction settings.<br><br>    `action`     - The action to take. Possible values are `Allow` or `Deny`.<br><br>    `ip_address` - The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`.<br><br>    `name`       - The name which should be used for this `ip_restriction`.<br><br>    `priority`   - The priority value of this `ip_restriction`. | <pre>list(object({<br>    action     = string<br>    ip_address = string<br>    name       = string<br>    priority   = string<br>  }))</pre> | `[]` | no |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | The name of the Service Plan that this Windows App Service will be created in. | `string` | n/a | yes |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | The object that describes some site configuration options for Windows WebApp<br><br>    `always_on`                                     - If this Windows Web App is Always On enabled. Defaults to true.<br>                                                      This option must be explicitly set to `false` when using `Free, F1, D1`, or `Shared` Service Plans.<br><br>    `container_registry_managed_identity_client_id` - The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.<br><br>    `container_registry_use_managed_identity`       - Should connections for Azure Container Registry use Managed Identity.<br><br>    `ftps_state`                                    - The State of FTP / FTPS service. Possible values include `AllAllowed`, `FtpsOnly`, and `Disabled`.<br><br>    `health_check_path`                             - The path to the Health Check.<br><br>    `http2_enabled`                                 - Should the HTTP2 be enabled?<br><br>    `load_balancing_mode`                           - The Site load balancing. Possible values include: `WeightedRoundRobin`, `LeastRequests`, `LeastResponseTime`, <br>                                                      `WeightedTotalTraffic`, `RequestHash`, `PerSiteRoundRobin`. Defaults to `LeastRequests` if omitted.<br><br>    `local_mysql_enabled`                           - Use Local MySQL. Defaults to `false`.<br><br>    `minimum_tls_version`                           - The configures the minimum version of TLS required for SSL requests. Possible values include: `1.0`, `1.1`, and `1.2`. <br>                                                      Defaults to `1.2`.<br><br>    `remote_debugging_enabled`                      - Should Remote Debugging be enabled? Defaults to `false`.<br><br>    `scm_use_main_ip_restriction`                   - Should the Windows Web App ip\_restriction configuration be used for the SCM also.<br><br>    `scm_minimum_tls_version`                       - The configures the minimum version of TLS required for SSL requests to the SCM site Possible values include: `1.0`, `1.1`, and `1.2`. <br>                                                      Defaults to `1.2`.<br>    `use_32_bit_worker`                             - Should the Windows Web App use a 32-bit worker.<br><br>    `vnet_route_all_enabled`                        - Should all outbound traffic have NAT Gateways, Network Security Groups and User Defined Routes applied? Defaults to `false`.<br><br>    `websockets_enabled`                            - Should Web Sockets be enabled? Defaults to `false`.<br><br>    `worker_count`                                  - The number of Workers for this Windows App Service. | <pre>object({<br>    always_on                                     = bool<br>    container_registry_managed_identity_client_id = string<br>    container_registry_use_managed_identity       = bool<br>    ftps_state                                    = string<br>    health_check_path                             = string<br>    http2_enabled                                 = bool<br>    load_balancing_mode                           = string<br>    local_mysql_enabled                           = bool<br>    minimum_tls_version                           = string<br>    remote_debugging_enabled                      = bool<br>    scm_use_main_ip_restriction                   = bool<br>    scm_minimum_tls_version                       = string<br>    use_32_bit_worker                             = bool<br>    vnet_route_all_enabled                        = bool<br>    websockets_enabled                            = bool<br>    worker_count                                  = number<br>  })</pre> | <pre>{<br>  "always_on": true,<br>  "container_registry_managed_identity_client_id": null,<br>  "container_registry_use_managed_identity": false,<br>  "ftps_state": "Disabled",<br>  "health_check_path": null,<br>  "http2_enabled": true,<br>  "load_balancing_mode": "LeastRequests",<br>  "local_mysql_enabled": false,<br>  "minimum_tls_version": "1.2",<br>  "remote_debugging_enabled": false,<br>  "scm_minimum_tls_version": "1.2",<br>  "scm_use_main_ip_restriction": false,<br>  "use_32_bit_worker": true,<br>  "vnet_route_all_enabled": false,<br>  "websockets_enabled": false,<br>  "worker_count": null<br>}</pre> | no |
| <a name="input_sticky_settings"></a> [sticky\_settings](#input\_sticky\_settings) | The object that describes sticky settings for Web App.<br><br>    `app_setting_names`       - A list of `app_setting` names that the Windows Web App will not swap between Slots when <br>                                a swap operation is triggered.<br>    `connection_string_names` - A list of connection\_string names that the Windows Web App will not swap between Slots when <br>                                a swap operation is triggered. | <pre>object({<br>    app_setting_names       = list(string)<br>    connection_string_names = list(string)<br>  })</pre> | `null` | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | The object that describes storage account settings for Web App.<br><br>    `access_key`   - The Access key for the storage account.<br><br>    `account_name` - The Name of the Storage Account.<br><br>    `name`         - The name which should be used for this Storage Account.<br><br>    `share_name`   - The Name of the File Share or Container Name for Blob storage.<br><br>    `type`         - The Azure Storage Type. Possible values include `AzureFiles` and `AzureBlob`<br><br>    `mount_path`   - The path at which to mount the storage share. | <pre>object({<br>    access_key   = string<br>    account_name = string<br>    name         = string<br>    share_name   = string<br>    type         = string<br>    mount_path   = string<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to the Windows Web App. | `map(string)` | `{}` | no |
| <a name="input_virtual_application"></a> [virtual\_application](#input\_virtual\_application) | The list of objects that describe virtual applications.<br><br>    `physical_path`     - The physical path for the Virtual Application.<br><br>    `preload`           - Should pre-loading be enabled. Defaults to `false`.<br><br>    `virtual_path`      - The Virtual Path for the Virtual Application.<br><br>    `virtual_directory` - The list of objects that describe virtual directories settings.<br><br>        `physical_path` - The physical path for the Virtual Application.<br>    <br>        `virtual_path`  - The Virtual Path for the Virtual Application. | <pre>list(object({<br>    physical_path = string<br>    preload       = bool<br>    virtual_path  = string<br>    virtual_directory = list(object({<br>      physical_path = string<br>      virtual_path  = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_web_app_slots"></a> [web\_app\_slots](#input\_web\_app\_slots) | The list of objects that describe Web App slots settings.<br><br>    `always_on`         - If this Windows Web App is Always On enabled. Defaults to `false`.<br><br>    `name`              - The name which should be used for this Windows Web App Slot. Changing this forces a new Windows Web App Slot to be created.<br><br>    `zip_deploy_file`   - The local path and filename of the Zip packaged application to deploy to this Windows Web App.<br>                          Using this value requires `WEBSITE_RUN_FROM_PACKAGE=1` to be set on the App in `app_settings`. <br>                          Refer to the Azure docs for further details.<br>    `application_stack` - The map that describes application stack settings<br>        `current_stack`             - The Application Stack for the Windows Web App. Possible values include `dotnet`, `dotnetcore`, <br>                                    `node`, `python`, `php`, and `java`.<br>                                    Whilst this property is Optional omitting it can cause unexpected behaviour, in particular for display <br>                                    of settings in the Azure Portal.<br>                                    The value of `dotnetcore` is for use in combination with `dotnet_version` set to `core3.1` only.<br>        `docker_container_name`     - The name of the Docker Container. For example `azure-app-service/samples/aspnethelloworld`.<br><br>        `docker_container_registry` - The registry Host on which the specified Docker Container can be located. For example `mcr.microsoft.com`<br><br>        `docker_container_tag`      - The Image Tag of the specified Docker Container to use. For example `latest`.<br><br>        `dotnet_version`            - The version of .NET to use when `current_stack` is set to `dotnet`. Possible values include `v2.0`, `v3.0`, <br>                                    `core3.1`, `v4.0`, `v5.0`, `v6.0` and `v7.0`.<br>        `java_container`            - The Java container type to use when `current_stack` is set to `java`. Possible values include `JAVA, `JETTY`, and `TOMCAT`. <br>                                    Required with `java\_version` and `java\_container\_version`.<br>        `java\_container\_version`    - The Version of the `java\_container` to use. Required with `java\_version` and `java\_container`. <br>                                <br>        `java\_version`              - The version of Java to use when `current\_stack` is set to `java`. Possible values include `1.7`, `1.8`, `11` and `17`. <br>                                    Required with `java\_container` and `java\_container\_version`.<br>                                    For compatible combinations of `java\_version`, `java\_container` and `java\_container\_version` users can use `az webapp list-runtimes` from command line.<br>        `node\_version`              - The version of node to use when `current\_stack` is set to `node`. Possible values include `12-LTS`, `14-LTS`, and `16-LTS`.<br>                                    This property conflicts with `java\_version`.<br>        `php\_version`               - The version of PHP to use when `current\_stack` is set to `php`. Possible values include `v7.4`.<br><br>        `python\_version`            - The version of Python to use when `current\_stack` is set to `python`. Possible values include `2.7` and `3.4.0`.<br><br>    `connection\_string` - The list of objects that describe connection string settings.<br><br>        `name`  - The name of the Connection String.<br><br>        `type`  - Type of database. Possible values include: `MySQL`, `SQLServer`, `SQLAzure`, `Custom`, <br>                `NotificationHub`, `ServiceBus`, `EventHub`, `APIHub`, `DocDb`, `RedisCache`, and `PostgreSQL`.<br><br>        `value` - The connection string value.<br><br>    `physical\_path`     - The physical path for the Virtual Application.<br><br>    `preload`           - Should pre-loading be enabled. Defaults to `false`.<br><br>    `virtual\_path`      - The Virtual Path for the Virtual Application.<br><br>    `virtual\_directory` - The list of objects that describe virtual directories settings.<br><br>        `physical\_path` - The physical path for the Virtual Application.<br><br>        `virtual\_path`  - The Virtual Path for the Virtual Application.<br><br>    `tags`  - A mapping of tags which should be assigned to the Windows Web App.<br><br>` | <pre>list(object({<br>    always_on         = bool<br>    name              = string<br>    zip_deploy_file   = string<br>    app_settings      = map(string)<br>    application_stack = map(string)<br>    tags              = map(string)<br>    connection_string = list(object({<br>      name  = string<br>      type  = string<br>      value = string<br>    }))<br>    virtual_application = list(object({<br>      physical_path = string<br>      preload       = bool<br>      virtual_path  = string<br>      virtual_directory = list(object({<br>        physical_path = string<br>        virtual_path  = string<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_zip_deploy_file"></a> [zip\_deploy\_file](#input\_zip\_deploy\_file) | The local path and filename of the Zip packaged application to deploy to this Windows Web App.<br>    Using this value requires `WEBSITE_RUN_FROM_PACKAGE=1` to be set on the App in `app_settings`. <br>    Refer to the Azure docs for further details. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | The default hostname of the Windows Web App. |
| <a name="output_windowswebapp_id"></a> [windowswebapp\_id](#output\_windowswebapp\_id) | The ID of the Windows Web App. |
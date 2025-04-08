variable "name" {
  description = "The name which should be used for this Windows Web App. Changing this forces a new Windows Web App to be created."
  type        = string
}
variable "rg_name" {
  description = "The name of the Resource Group where the Windows Web App should exist. Changing this forces a new Windows Web App to be created."
  type        = string
}
variable "location" {
  description = <<EOF
    The Azure Region where the Windows Web App should exist. Changing this forces a new Windows Web App to be created.
    If the parameter is not specified in the configuration file, the location of the resource group is used.
    EOF
  type        = string
  default     = null
}
variable "service_plan_name" {
  description = "The name of the Service Plan that this Windows App Service will be created in."
  type        = string
}
variable "https_only" {
  description = "Should the Windows Web App require HTTPS connections."
  type        = bool
  default     = false
}
variable "site_config" {
  description = <<EOF
    The object that describes some site configuration options for Windows WebApp

    `always_on`                                     - If this Windows Web App is Always On enabled. Defaults to true.  
                                                      This option must be explicitly set to `false` when using `Free, F1, D1`, or `Shared` Service Plans.

    `container_registry_managed_identity_client_id` - The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.

    `container_registry_use_managed_identity`       - Should connections for Azure Container Registry use Managed Identity.

    `ftps_state`                                    - The State of FTP / FTPS service. Possible values include `AllAllowed`, `FtpsOnly`, and `Disabled`.

    `health_check_path`                             - The path to the Health Check.

    `http2_enabled`                                 - Should the HTTP2 be enabled?

    `load_balancing_mode`                           - The Site load balancing. Possible values include: `WeightedRoundRobin`, `LeastRequests`, `LeastResponseTime`, 
                                                      `WeightedTotalTraffic`, `RequestHash`, `PerSiteRoundRobin`. Defaults to `LeastRequests` if omitted.

    `local_mysql_enabled`                           - Use Local MySQL. Defaults to `false`.

    `minimum_tls_version`                           - The configures the minimum version of TLS required for SSL requests. Possible values include: `1.0`, `1.1`, and `1.2`. 
                                                      Defaults to `1.2`.

    `remote_debugging_enabled`                      - Should Remote Debugging be enabled? Defaults to `false`.

    `scm_use_main_ip_restriction`                   - Should the Windows Web App ip_restriction configuration be used for the SCM also.

    `scm_minimum_tls_version`                       - The configures the minimum version of TLS required for SSL requests to the SCM site Possible values include: `1.0`, `1.1`, and `1.2`. 
                                                      Defaults to `1.2`.
    `use_32_bit_worker`                             - Should the Windows Web App use a 32-bit worker.

    `vnet_route_all_enabled`                        - Should all outbound traffic have NAT Gateways, Network Security Groups and User Defined Routes applied? Defaults to `false`.

    `websockets_enabled`                            - Should Web Sockets be enabled? Defaults to `false`.

    `worker_count`                                  - The number of Workers for this Windows App Service.


    EOF
  type = object({
    always_on                                     = bool
    container_registry_managed_identity_client_id = string
    container_registry_use_managed_identity       = bool
    ftps_state                                    = string
    health_check_path                             = string
    http2_enabled                                 = bool
    load_balancing_mode                           = string
    local_mysql_enabled                           = bool
    minimum_tls_version                           = string
    remote_debugging_enabled                      = bool
    scm_use_main_ip_restriction                   = bool
    scm_minimum_tls_version                       = string
    use_32_bit_worker                             = bool
    vnet_route_all_enabled                        = bool
    websockets_enabled                            = bool
    worker_count                                  = number
  })
  default = {
    always_on                                     = true
    container_registry_managed_identity_client_id = null
    container_registry_use_managed_identity       = false
    ftps_state                                    = "Disabled"
    health_check_path                             = null
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
    worker_count                                  = null
  }
}
variable "application_stack" {
  description = <<EOF
    The map that describes application stack settings

    `current_stack`             - The Application Stack for the Windows Web App. Possible values include `dotnet`, `dotnetcore`, 
                                  `node`, `python`, `php`, and `java`.
                                  Whilst this property is Optional omitting it can cause unexpected behaviour, in particular for display 
                                  of settings in the Azure Portal.
                                  The value of `dotnetcore` is for use in combination with `dotnet_version` set to `core3.1` only.
    `docker_container_name`     - The name of the Docker Container. For example `azure-app-service/samples/aspnethelloworld`.

    `docker_container_registry` - The registry Host on which the specified Docker Container can be located. For example `mcr.microsoft.com`

    `docker_container_tag`      - The Image Tag of the specified Docker Container to use. For example `latest`.

    `dotnet_version`            - The version of .NET to use when `current_stack` is set to `dotnet`. Possible values include `v2.0`, `v3.0`, 
                                  `core3.1`, `v4.0`, `v5.0`, `v6.0` and `v7.0`.
    `java_container`            - The Java container type to use when `current_stack` is set to `java`. Possible values include `JAVA, `JETTY`, and `TOMCAT`. 
                                  Required with `java_version` and `java_container_version`.
    `java_container_version`    - The Version of the `java_container` to use. Required with `java_version` and `java_container`. 
                                  
    `java_version`              - The version of Java to use when `current_stack` is set to `java`. Possible values include `1.7`, `1.8`, `11` and `17`. 
                                  Required with `java_container` and `java_container_version`.
                                  For compatible combinations of `java_version`, `java_container` and `java_container_version` users can use `az webapp list-runtimes` from command line.
    `node_version`              - The version of node to use when `current_stack` is set to `node`. Possible values include `12-LTS`, `14-LTS`, and `16-LTS`.
                                  This property conflicts with `java_version`.
    `php_version`               - The version of PHP to use when `current_stack` is set to `php`. Possible values include `v7.4`.

    `python_version`            - The version of Python to use when `current_stack` is set to `python`. Possible values include `2.7` and `3.4.0`.

    EOF
  type        = map(string)
  default     = null
}
variable "virtual_application" {
  description = <<EOF
    The list of objects that describe virtual applications.

    `physical_path`     - The physical path for the Virtual Application.

    `preload`           - Should pre-loading be enabled. Defaults to `false`.

    `virtual_path`      - The Virtual Path for the Virtual Application.

    `virtual_directory` - The list of objects that describe virtual directories settings.

        `physical_path` - The physical path for the Virtual Application.
        
        `virtual_path`  - The Virtual Path for the Virtual Application.

    EOF
  type = list(object({
    physical_path = string
    preload       = bool
    virtual_path  = string
    virtual_directory = list(object({
      physical_path = string
      virtual_path  = string
    }))
  }))
  default = []
}
variable "auto_heal_setting" {
  description = <<EOF
    The object that describes auto heal settings

    `auto_heal_enabled` -  Should Auto heal rules be enabled? Required with auto_heal_setting.

    `action`  - The object that describes actions for auto heal
        `action_type`                    - Predefined action to be taken to an Auto Heal trigger. Possible values include: `Recycle`, `LogEvent`, and `CustomAction`.
        `minimum_process_execution_time` - The minimum amount of time in `hh:mm:ss` the Windows Web App must have been running before the defined action will be run in the event of a trigger.

    `trigger` - The object that describes trigger for auto heal
        `private_memory_kb` -  The amount of Private Memory to be consumed for this rule to trigger. 
                               Possible values are between `102400` and `13631488`. 
        `requests`          - The object that describes trigger requests for auto heal.
            `count`       - The number of requests in the specified `interval` to trigger this rule.
            `interval`    - The interval in `hh:mm:ss`.

        `slow_request`      - The object that describes trigger slow requests for auto heal.
            `count`       - The number of Slow Requests in the time `interval` to trigger this rule.
            `interval`    - The time interval in the form `hh:mm:ss`.
            `time_taken`  - The threshold of time passed to qualify as a Slow Request in `hh:mm:ss`.
            `path`        - The path for which this slow request rule applies.

        `status_code`       - The object that describe status code settings for auto heal trigger.
            `count`             - The number of occurrences of the defined `status_code` in the specified `interval`
                                on which to trigger this rule.
            `interval`          - The time interval in the form `hh:mm:ss`.
            `status_code_range` - The status code for this rule, accepts single status codes and status code ranges. e.g. 
                                `500` or `400-499`. Possible values are integers between `101` and `599`.
            `path`              - The path to which this rule status code applies.
            `sub_status`        - The Request Sub Status of the Status Code.
            `win32_status`      - The Win32 Status Code of the Request.


    EOF
  type = object({
    auto_heal_enabled = bool
    action = object({
      action_type                    = string
      minimum_process_execution_time = string
      custom_action                  = object({})
    })
    trigger = object({
      private_memory_kb = number
      requests = object({
        count    = number
        interval = string
      })
      slow_request = object({
        count      = number
        interval   = string
        time_taken = string
        path       = string
      })
      status_code = object({
        count             = number
        interval          = string
        status_code_range = string
        path              = string
        sub_status        = string
        win32_status      = string
      })
    })
  })
  default = null
}
variable "ip_restriction" {
  description = <<EOF
    The list of objects that describes ip restrictions for site config.

    `action`     - The action to take. Possible values are `Allow` or `Deny`.

    `ip_address` - The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`.

    `name`       - The name which should be used for this `ip_restriction`.

    `priority`   - The priority value of this `ip_restriction`.

    EOF
  type = list(object({
    action     = string
    ip_address = string
    name       = string
    priority   = string
  }))
  default = []
}
variable "scm_ip_restriction" {
  description = <<EOF
    The list of objects that describes scm ip restriction settings.

    `action`     - The action to take. Possible values are `Allow` or `Deny`.

    `ip_address` - The CIDR notation of the IP or IP Range to match. For example: `10.0.0.0/24` or `192.168.10.1/32`.

    `name`       - The name which should be used for this `ip_restriction`.

    `priority`   - The priority value of this `ip_restriction`.

    EOF
  type = list(object({
    action     = string
    ip_address = string
    name       = string
    priority   = string
  }))
  default = []
}
variable "app_settings" {
  description = "A map of key-value pairs of App Settings."
  type        = map(string)
  default     = {}
}
variable "backup" {
  description = <<EOF
    The object that describes windows webapp backup settings.

    `name`               - The name which should be used for this Backup.
    `schedule`           - The object that describes backup schedule.
        `frequency_interval`       - How often the backup should be executed (e.g. for weekly backup, 
                                     this should be set to `7` and `frequency_unit` should be set to `Day`).
                                     Not all intervals are supported on all Windows Web App SKUs. Please refer 
                                     to the official documentation for appropriate values.
        `frequency_unit`           - The unit of time for how often the backup should take place. Possible values
                                     include: `Day`, `Hour`.

        `keep_at_least_one_backup` - Should the service keep at least one backup, regardless of the age of backup? 
                                     Defaults to `false`.
        `retention_period_days`    - After how many days backups should be deleted.

        `start_time`               - When the schedule should start working in `RFC-3339` format.

    `storage_account_url` - The SAS URL to the container.

    `enabled`             - Should this backup job be enabled?

    EOF
  type = object({
    name = string
    schedule = object({
      frequency_interval       = string
      frequency_unit           = string
      keep_at_least_one_backup = bool
      retention_period_days    = number
      start_time               = string
    })
    storage_account_url = string
    enabled             = bool
  })
  default = null
}
variable "connection_string" {
  description = <<EOF
    The list of objects that describe connection string settings.

    `name`  - The name of the Connection String.

    `type`  - Type of database. Possible values include: `MySQL`, `SQLServer`, `SQLAzure`, `Custom`, 
              `NotificationHub`, `ServiceBus`, `EventHub`, `APIHub`, `DocDb`, `RedisCache`, and `PostgreSQL`.

    `value` - The connection string value.

    EOF
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = null
}
variable "identity" {
  description = <<EOF
    The object describes identity settings.

    `type`         - Specifies the type of Managed Service Identity that should be configured on this Windows Web App. 
                     Possible values are `SystemAssigned`, and `UserAssigned`, and `SystemAssigned, UserAssigned` (to enable both).

    `identity_ids` - A list of User Assigned Managed Identity IDs to be assigned to this Windows Web App.
                     This is required when type is set to `UserAssigned` or `SystemAssigned, UserAssigned`.

    EOF
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = null
}
variable "regional_network_integration" {
  description = <<EOF
    The object that describes subnet for regional network integration for webapp.

    `subnet_name`  - The subnet name which will be used by this Web App for regional virtual network integration.

    `vnet_name`    - The VNET name where subnet exists.

    `vnet_rg_name` - The resource group name where VNET exists.

    EOF
  type = object({
    subnet_name  = string
    vnet_name    = string
    vnet_rg_name = string
  })
  default = null
}
variable "logs" {
  description = <<EOF
    The object that describes settings for Web App logs.

    `detailed_error_messages` - Should detailed error messages be enabled?

    `failed_request_tracing`  - Should the failed request tracing be enabled?

    `application_logs`        - The object that describes application logs settings.
        `file_system_level` - Log level. Possible values include: `Verbose`, `Information`, `Warning`, and `Error`.

    `http_logs`               - The object that describes https logs settings.
        `file_system` - The object that describes file system settings
            `retention_in_days` - The retention period in days. A value of 0 means no retention.
            `retention_in_mb`   - The maximum size in megabytes that log files can use.

    `azure_blob_storage`      - The object that describe azure blob settings for Web App logs.
        `level`             - The level at which to log. Possible values include `Error`, `Warning`, `Information`, `Verbose` and `Off`.
                              This field is not available for `http_logs`.
        `retention_in_days` - The time in days after which to remove blobs. A value of `0` means no retention.

        `sas_url`           - SAS url to an Azure blob container with read/write/list/delete permissions.

    EOF
  type = object({
    detailed_error_messages = bool
    failed_request_tracing  = bool
    application_logs = object({
      file_system_level = string
    })
    http_logs = object({
      file_system = object({
        retention_in_days = number
        retention_in_mb   = number
      })
    })
    azure_blob_storage = object({
      level             = string
      retention_in_days = number
      sas_url           = string
    })
  })
  default = null
}
variable "storage_account" {
  description = <<EOF
    The object that describes storage account settings for Web App.
    
    `access_key`   - The Access key for the storage account.

    `account_name` - The Name of the Storage Account.

    `name`         - The name which should be used for this Storage Account.

    `share_name`   - The Name of the File Share or Container Name for Blob storage.

    `type`         - The Azure Storage Type. Possible values include `AzureFiles` and `AzureBlob`

    `mount_path`   - The path at which to mount the storage share.

    EOF
  type = object({
    access_key   = string
    account_name = string
    name         = string
    share_name   = string
    type         = string
    mount_path   = string
  })
  default = null
}
variable "sticky_settings" {
  description = <<EOF
    The object that describes sticky settings for Web App.

    `app_setting_names`       - A list of `app_setting` names that the Windows Web App will not swap between Slots when 
                                a swap operation is triggered.
    `connection_string_names` - A list of connection_string names that the Windows Web App will not swap between Slots when 
                                a swap operation is triggered.

    EOF
  type = object({
    app_setting_names       = list(string)
    connection_string_names = list(string)
  })
  default = null
}
variable "zip_deploy_file" {
  description = <<EOF
    The local path and filename of the Zip packaged application to deploy to this Windows Web App.
    Using this value requires `WEBSITE_RUN_FROM_PACKAGE=1` to be set on the App in `app_settings`. 
    Refer to the Azure docs for further details.

    EOF
  type        = string
  default     = null
}
variable "web_app_slots" {
  description = <<EOF
    The list of objects that describe Web App slots settings.

    `always_on`         - If this Windows Web App is Always On enabled. Defaults to `false`.

    `name`              - The name which should be used for this Windows Web App Slot. Changing this forces a new Windows Web App Slot to be created.

    `zip_deploy_file`   - The local path and filename of the Zip packaged application to deploy to this Windows Web App.
                          Using this value requires `WEBSITE_RUN_FROM_PACKAGE=1` to be set on the App in `app_settings`. 
                          Refer to the Azure docs for further details.
    `application_stack` - The map that describes application stack settings
        `current_stack`             - The Application Stack for the Windows Web App. Possible values include `dotnet`, `dotnetcore`, 
                                    `node`, `python`, `php`, and `java`.
                                    Whilst this property is Optional omitting it can cause unexpected behaviour, in particular for display 
                                    of settings in the Azure Portal.
                                    The value of `dotnetcore` is for use in combination with `dotnet_version` set to `core3.1` only.
        `docker_container_name`     - The name of the Docker Container. For example `azure-app-service/samples/aspnethelloworld`.

        `docker_container_registry` - The registry Host on which the specified Docker Container can be located. For example `mcr.microsoft.com`

        `docker_container_tag`      - The Image Tag of the specified Docker Container to use. For example `latest`.

        `dotnet_version`            - The version of .NET to use when `current_stack` is set to `dotnet`. Possible values include `v2.0`, `v3.0`, 
                                    `core3.1`, `v4.0`, `v5.0`, `v6.0` and `v7.0`.
        `java_container`            - The Java container type to use when `current_stack` is set to `java`. Possible values include `JAVA, `JETTY`, and `TOMCAT`. 
                                    Required with `java_version` and `java_container_version`.
        `java_container_version`    - The Version of the `java_container` to use. Required with `java_version` and `java_container`. 
                                    
        `java_version`              - The version of Java to use when `current_stack` is set to `java`. Possible values include `1.7`, `1.8`, `11` and `17`. 
                                    Required with `java_container` and `java_container_version`.
                                    For compatible combinations of `java_version`, `java_container` and `java_container_version` users can use `az webapp list-runtimes` from command line.
        `node_version`              - The version of node to use when `current_stack` is set to `node`. Possible values include `12-LTS`, `14-LTS`, and `16-LTS`.
                                    This property conflicts with `java_version`.
        `php_version`               - The version of PHP to use when `current_stack` is set to `php`. Possible values include `v7.4`.

        `python_version`            - The version of Python to use when `current_stack` is set to `python`. Possible values include `2.7` and `3.4.0`.
    
    `connection_string` - The list of objects that describe connection string settings.

        `name`  - The name of the Connection String.

        `type`  - Type of database. Possible values include: `MySQL`, `SQLServer`, `SQLAzure`, `Custom`, 
                `NotificationHub`, `ServiceBus`, `EventHub`, `APIHub`, `DocDb`, `RedisCache`, and `PostgreSQL`.

        `value` - The connection string value.

    `physical_path`     - The physical path for the Virtual Application.

    `preload`           - Should pre-loading be enabled. Defaults to `false`.

    `virtual_path`      - The Virtual Path for the Virtual Application.

    `virtual_directory` - The list of objects that describe virtual directories settings.

        `physical_path` - The physical path for the Virtual Application.

        `virtual_path`  - The Virtual Path for the Virtual Application.

    `tags`  - A mapping of tags which should be assigned to the Windows Web App.

    EOF
  type = list(object({
    always_on         = bool
    name              = string
    zip_deploy_file   = string
    app_settings      = map(string)
    application_stack = map(string)
    tags              = map(string)
    connection_string = list(object({
      name  = string
      type  = string
      value = string
    }))
    virtual_application = list(object({
      physical_path = string
      preload       = bool
      virtual_path  = string
      virtual_directory = list(object({
        physical_path = string
        virtual_path  = string
      }))
    }))
  }))
  default = []
}

variable "diagnostic_setting" {
  description = <<EOF
  The description of parameters for Diagnistic Setting:
    `diagnostic_setting_name` - specifies the name of the Diagnostic Setting;
    `log_analytics_workspace_id` - ID of the Log Analytics Workspace;
    `storage_account_id` - the ID of the Storage Account where logs should be sent;
    `log` - describes logs for Diagnistic Setting: 
      `category` -  the name of a Diagnostic Log Category for this Resource. list of 
        available logs: 
        _AppServicePlatformLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceplatformlogs) ;
        _AppServiceIPSecAuditLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceipsecauditlogs));
        _AppServiceAuditLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceauditlogs);
        _AppServiceConsoleLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceconsolelogs);
        _AppServiceHTTPLogs_ - [log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appservicehttplogs);
        _AppServiceAppLogs_ -[log description](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/appserviceapplogs);
      `enabled` -  is this Diagnostic Log enabled?;
      `retention_policy` - describes logs retention policy (needed to store data in the Storage Account):
        `enabled` - is this Retention Policy enabled?
        `days` - the number of days for which this Retention Policy should apply.
    `metric` - describes metric for Diagnistic Setting:
      `category` -  the name of a Diagnostic Metric Category for this Resource. List of
        available Metrics: _AllMetrics_ ;
      `enabled` -  is this Diagnostic Metric enabled?
      `retention_policy` - describes Metric retention policy (needed to store data in the Storage Account):
        `enabled` - is this Retention Policy enabled?;
        `days` - the number of days for which this Retention Policy should apply.
  EOF
  type        = any
  default     = null
}

variable "tags" {
  description = "A mapping of tags which should be assigned to the Windows Web App."
  type        = map(string)
  default     = {}
}
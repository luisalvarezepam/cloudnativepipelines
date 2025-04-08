# Get resource group data
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

# Get Azure Service Plan data
data "azurerm_service_plan" "webapp" {
  name                = var.service_plan_name
  resource_group_name = var.rg_name
}

# Get subnet data
data "azurerm_subnet" "webapp" {
  count                = var.regional_network_integration != null ? 1 : 0
  name                 = var.regional_network_integration.subnet_name
  virtual_network_name = var.regional_network_integration.vnet_name
  resource_group_name  = var.regional_network_integration.vnet_rg_name
}

# Create Windows application service
resource "azurerm_windows_web_app" "webapp" {
  name                      = var.name
  resource_group_name       = var.rg_name
  location                  = var.location == null ? data.azurerm_resource_group.rg.location : var.location
  service_plan_id           = data.azurerm_service_plan.webapp.id
  app_settings              = var.app_settings
  https_only                = var.https_only
  virtual_network_subnet_id = var.regional_network_integration != null ? data.azurerm_subnet.webapp[0].id : null
  zip_deploy_file           = var.zip_deploy_file
  tags                      = var.tags
  site_config {
    always_on                                     = var.site_config.always_on
    container_registry_managed_identity_client_id = var.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = var.site_config.container_registry_use_managed_identity
    ftps_state                                    = var.site_config.ftps_state
    health_check_path                             = var.site_config.health_check_path
    http2_enabled                                 = var.site_config.http2_enabled
    auto_heal_enabled                             = var.auto_heal_setting != null ? var.auto_heal_setting.auto_heal_enabled : null
    load_balancing_mode                           = var.site_config.load_balancing_mode
    local_mysql_enabled                           = var.site_config.local_mysql_enabled
    minimum_tls_version                           = var.site_config.minimum_tls_version
    remote_debugging_enabled                      = var.site_config.remote_debugging_enabled
    scm_use_main_ip_restriction                   = var.site_config.scm_use_main_ip_restriction
    scm_minimum_tls_version                       = var.site_config.scm_minimum_tls_version
    use_32_bit_worker                             = var.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = var.site_config.vnet_route_all_enabled
    websockets_enabled                            = var.site_config.websockets_enabled
    worker_count                                  = var.site_config.worker_count
    dynamic "application_stack" {
      for_each = var.application_stack != null ? [1] : []
      content {
        current_stack             = lookup(var.application_stack, "current_stack", null)
        docker_container_name     = lookup(var.application_stack, "docker_container_name", null)
        docker_container_registry = lookup(var.application_stack, "docker_container_registry", null)
        docker_container_tag      = lookup(var.application_stack, "docker_container_tag", null)
        dotnet_version            = lookup(var.application_stack, "dotnet_version", null)
        java_container            = lookup(var.application_stack, "java_container", null)
        java_container_version    = lookup(var.application_stack, "java_container_version", null)
        java_version              = lookup(var.application_stack, "java_version", null)
        node_version              = lookup(var.application_stack, "node_version", null)
        php_version               = lookup(var.application_stack, "php_version", null)
        python_version            = lookup(var.application_stack, "python_version", null)

      }
    }
    dynamic "virtual_application" {
      for_each = { for application in var.virtual_application : application.physical_path => application }
      content {
        physical_path = virtual_application.value.physical_path
        preload       = virtual_application.value.preload
        virtual_path  = virtual_application.value.virtual_path
        dynamic "virtual_directory" {
          for_each = { for directory in virtual_application.value.virtual_directory : directory.physical_path => directory }
          content {
            physical_path = virtual_directory.value.physical_path
            virtual_path  = virtual_directory.value.virtual_path
          }
        }
      }
    }
    dynamic "auto_heal_setting" {
      for_each = var.auto_heal_setting != null ? [1] : []
      content {
        dynamic "action" {
          for_each = var.auto_heal_setting.action != null ? [1] : []
          content {
            action_type                    = var.auto_heal_setting.action.action_type
            minimum_process_execution_time = var.auto_heal_setting.action.minimum_process_execution_time
          }
        }
        dynamic "trigger" {
          for_each = var.auto_heal_setting.trigger != null ? [1] : []
          content {
            private_memory_kb = var.auto_heal_setting.trigger.private_memory_kb
            dynamic "requests" {
              for_each = var.auto_heal_setting.trigger.requests != null ? [1] : []
              content {
                count    = var.auto_heal_setting.trigger.requests.count
                interval = var.auto_heal_setting.trigger.requests.interval
              }
            }
            dynamic "slow_request" {
              for_each = var.auto_heal_setting.trigger.slow_request != null ? [1] : []
              content {
                count      = var.auto_heal_setting.trigger.slow_request.count
                interval   = var.auto_heal_setting.trigger.slow_request.interval
                time_taken = var.auto_heal_setting.trigger.slow_request.time_taken
                path       = var.auto_heal_setting.trigger.slow_request.path
              }
            }
            dynamic "status_code" {
              for_each = var.auto_heal_setting.trigger.status_code != null ? [1] : []
              content {
                count             = var.auto_heal_setting.trigger.status_code.count
                interval          = var.auto_heal_setting.trigger.status_code.interval
                status_code_range = var.auto_heal_setting.trigger.status_code.status_code_range
                path              = var.auto_heal_setting.trigger.status_code.path
                sub_status        = var.auto_heal_setting.trigger.status_code.sub_status
                win32_status      = var.auto_heal_setting.trigger.status_code.win32_status
              }
            }
          }
        }
      }
    }
    dynamic "ip_restriction" {
      for_each = { for restriction in var.ip_restriction : restriction.name => restriction }
      content {
        name       = ip_restriction.value.name
        action     = ip_restriction.value.action
        ip_address = ip_restriction.value.ip_address
        priority   = ip_restriction.value.priority
      }
    }
    dynamic "scm_ip_restriction" {
      for_each = { for restriction in var.scm_ip_restriction : restriction.name => restriction }
      content {
        name       = scm_ip_restriction.value.name
        action     = scm_ip_restriction.value.action
        ip_address = scm_ip_restriction.value.ip_address
        priority   = scm_ip_restriction.value.priority
      }
    }
  }
  dynamic "backup" {
    for_each = var.backup != null ? [1] : []
    content {
      name                = var.backup.name
      storage_account_url = var.backup.storage_account_url
      enabled             = var.backup.enabled
      schedule {
        frequency_interval       = var.backup.schedule.frequency_interval
        frequency_unit           = var.backup.schedule.frequency_unit
        keep_at_least_one_backup = var.backup.schedule.keep_at_least_one_backup
        retention_period_days    = var.backup.schedule.retention_period_days
        start_time               = var.backup.schedule.start_time
      }
    }
  }
  dynamic "connection_string" {
    for_each = { for connection_string in var.connection_string : connection_string.name => connection_string }
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = sensitive(connection_string.value.value)
    }
  }
  dynamic "identity" {

    for_each = var.identity != null ? [1] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }
  dynamic "logs" {
    for_each = var.logs != null ? [1] : []
    content {
      detailed_error_messages = var.logs.detailed_error_messages
      failed_request_tracing  = var.logs.failed_request_tracing
      dynamic "application_logs" {
        for_each = var.logs.application_logs != null ? [1] : []
        content {
          file_system_level = var.logs.application_logs.file_system_level
          dynamic "azure_blob_storage" {
            for_each = var.logs.azure_blob_storage != null ? [1] : []
            content {
              level             = var.logs.azure_blob_storage.level
              retention_in_days = var.logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.azure_blob_storage.sas_url
            }
          }
        }
      }
      dynamic "http_logs" {
        for_each = var.logs.http_logs != null ? [1] : []
        content {
          file_system {
            retention_in_days = var.logs.http_logs.file_system.retention_in_days
            retention_in_mb   = var.logs.http_logs.file_system.retention_in_mb
          }
          dynamic "azure_blob_storage" {
            for_each = var.logs.azure_blob_storage != null ? [1] : []
            content {
              retention_in_days = var.logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.azure_blob_storage.sas_url
            }
          }
        }
      }
    }
  }
  dynamic "storage_account" {
    for_each = var.storage_account != null ? [1] : []
    content {
      access_key   = sensitive(var.storage_account.access_key)
      account_name = var.storage_account.account_name
      name         = var.storage_account.name
      share_name   = var.storage_account.share_name
      type         = var.storage_account.type
      mount_path   = var.storage_account.mount_path
    }
  }
  dynamic "sticky_settings" {
    for_each = var.sticky_settings != null ? [1] : []
    content {
      connection_string_names = var.sticky_settings.connection_string_names
      app_setting_names       = var.sticky_settings.app_setting_names
    }
  }
}

# Create Windows Web App slots
resource "azurerm_windows_web_app_slot" "webapp" {
  count                     = length(var.web_app_slots)
  name                      = var.web_app_slots[count.index].name
  app_service_id            = azurerm_windows_web_app.webapp.id
  app_settings              = var.web_app_slots[count.index].app_settings
  virtual_network_subnet_id = var.regional_network_integration != null ? data.azurerm_subnet.webapp[0].id : null
  zip_deploy_file           = var.web_app_slots[count.index].zip_deploy_file
  tags                      = var.web_app_slots[count.index].tags
  site_config {
    always_on                                     = var.web_app_slots[count.index].always_on
    container_registry_managed_identity_client_id = var.site_config.container_registry_managed_identity_client_id
    container_registry_use_managed_identity       = var.site_config.container_registry_use_managed_identity
    ftps_state                                    = var.site_config.ftps_state
    health_check_path                             = var.site_config.health_check_path
    http2_enabled                                 = var.site_config.http2_enabled
    auto_heal_enabled                             = var.auto_heal_setting != null ? var.auto_heal_setting.auto_heal_enabled : null
    load_balancing_mode                           = var.site_config.load_balancing_mode
    local_mysql_enabled                           = var.site_config.local_mysql_enabled
    minimum_tls_version                           = var.site_config.minimum_tls_version
    remote_debugging_enabled                      = var.site_config.remote_debugging_enabled
    scm_use_main_ip_restriction                   = var.site_config.scm_use_main_ip_restriction
    scm_minimum_tls_version                       = var.site_config.scm_minimum_tls_version
    use_32_bit_worker                             = var.site_config.use_32_bit_worker
    vnet_route_all_enabled                        = var.site_config.vnet_route_all_enabled
    websockets_enabled                            = var.site_config.websockets_enabled
    worker_count                                  = var.site_config.worker_count
    dynamic "application_stack" {
      for_each = var.web_app_slots[count.index].application_stack != null ? [1] : []
      content {
        current_stack             = lookup(var.web_app_slots[count.index].application_stack, "current_stack", null)
        docker_container_name     = lookup(var.web_app_slots[count.index].application_stack, "docker_container_name", null)
        docker_container_registry = lookup(var.web_app_slots[count.index].application_stack, "docker_container_registry", null)
        docker_container_tag      = lookup(var.web_app_slots[count.index].application_stack, "docker_container_tag", null)
        dotnet_version            = lookup(var.web_app_slots[count.index].application_stack, "dotnet_version", null)
        java_container            = lookup(var.web_app_slots[count.index].application_stack, "java_container", null)
        java_container_version    = lookup(var.web_app_slots[count.index].application_stack, "java_container_version", null)
        java_version              = lookup(var.web_app_slots[count.index].application_stack, "java_version", null)
        node_version              = lookup(var.web_app_slots[count.index].application_stack, "node_version", null)
        php_version               = lookup(var.web_app_slots[count.index].application_stack, "php_version", null)
        python_version            = lookup(var.web_app_slots[count.index].application_stack, "python_version", null)

      }
    }
    dynamic "virtual_application" {
      for_each = { for application in var.web_app_slots[count.index].virtual_application : application.physical_path => application }
      content {
        physical_path = virtual_application.value.physical_path
        preload       = virtual_application.value.preload
        virtual_path  = virtual_application.value.virtual_path
        dynamic "virtual_directory" {
          for_each = { for directory in virtual_application.value.virtual_directory : directory.physical_path => directory }
          content {
            physical_path = virtual_directory.value.physical_path
            virtual_path  = virtual_directory.value.virtual_path
          }
        }
      }
    }
    dynamic "auto_heal_setting" {
      for_each = var.auto_heal_setting != null ? [1] : []
      content {
        dynamic "action" {
          for_each = var.auto_heal_setting.action != null ? [1] : []
          content {
            action_type                    = var.auto_heal_setting.action.action_type
            minimum_process_execution_time = var.auto_heal_setting.action.minimum_process_execution_time
          }
        }
        dynamic "trigger" {
          for_each = var.auto_heal_setting.trigger != null ? [1] : []
          content {
            private_memory_kb = var.auto_heal_setting.trigger.private_memory_kb
            dynamic "requests" {
              for_each = var.auto_heal_setting.trigger.requests != null ? [1] : []
              content {
                count    = var.auto_heal_setting.trigger.requests.count
                interval = var.auto_heal_setting.trigger.requests.interval
              }
            }
            dynamic "slow_request" {
              for_each = var.auto_heal_setting.trigger.slow_request != null ? [1] : []
              content {
                count      = var.auto_heal_setting.trigger.slow_request.count
                interval   = var.auto_heal_setting.trigger.slow_request.interval
                time_taken = var.auto_heal_setting.trigger.slow_request.time_taken
                path       = var.auto_heal_setting.trigger.slow_request.path
              }
            }
            dynamic "status_code" {
              for_each = var.auto_heal_setting.trigger.status_code != null ? [1] : []
              content {
                count             = var.auto_heal_setting.trigger.status_code.count
                interval          = var.auto_heal_setting.trigger.status_code.interval
                status_code_range = var.auto_heal_setting.trigger.status_code.status_code_range
                path              = var.auto_heal_setting.trigger.status_code.path
                sub_status        = var.auto_heal_setting.trigger.status_code.sub_status
                win32_status      = var.auto_heal_setting.trigger.status_code.win32_status
              }
            }
          }
        }
      }
    }
    dynamic "ip_restriction" {
      for_each = { for restriction in var.ip_restriction : restriction.name => restriction }
      content {
        name       = ip_restriction.value.name
        action     = ip_restriction.value.action
        ip_address = ip_restriction.value.ip_address
        priority   = ip_restriction.value.priority
      }
    }
    dynamic "scm_ip_restriction" {
      for_each = { for restriction in var.scm_ip_restriction : restriction.name => restriction }
      content {
        name       = scm_ip_restriction.value.name
        action     = scm_ip_restriction.value.action
        ip_address = scm_ip_restriction.value.ip_address
        priority   = scm_ip_restriction.value.priority
      }
    }
  }
  dynamic "backup" {
    for_each = var.backup != null ? [1] : []
    content {
      name                = var.backup.name
      storage_account_url = var.backup.storage_account_url
      enabled             = var.backup.enabled
      schedule {
        frequency_interval       = var.backup.schedule.frequency_interval
        frequency_unit           = var.backup.schedule.frequency_unit
        keep_at_least_one_backup = var.backup.schedule.keep_at_least_one_backup
        retention_period_days    = var.backup.schedule.retention_period_days
        start_time               = var.backup.schedule.start_time
      }
    }
  }
  dynamic "connection_string" {
    for_each = { for connection_string in var.web_app_slots[count.index].connection_string : connection_string.name => connection_string }
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = sensitive(connection_string.value.value)
    }
  }
  dynamic "identity" {
    for_each = var.identity != null ? [1] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }
  dynamic "logs" {
    for_each = var.logs != null ? [1] : []
    content {
      detailed_error_messages = var.logs.detailed_error_messages
      failed_request_tracing  = var.logs.failed_request_tracing
      dynamic "application_logs" {
        for_each = var.logs.application_logs != null ? [1] : []
        content {
          file_system_level = var.logs.application_logs.file_system_level
          dynamic "azure_blob_storage" {
            for_each = var.logs.azure_blob_storage != null ? [1] : []
            content {
              level             = var.logs.azure_blob_storage.level
              retention_in_days = var.logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.azure_blob_storage.sas_url
            }
          }
        }
      }
      dynamic "http_logs" {
        for_each = var.logs.http_logs != null ? [1] : []
        content {
          file_system {
            retention_in_days = var.logs.http_logs.file_system.retention_in_days
            retention_in_mb   = var.logs.http_logs.file_system.retention_in_mb
          }
          dynamic "azure_blob_storage" {
            for_each = var.logs.azure_blob_storage != null ? [1] : []
            content {
              retention_in_days = var.logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.azure_blob_storage.sas_url
            }
          }
        }
      }
    }
  }
  dynamic "storage_account" {
    for_each = var.storage_account != null ? [1] : []
    content {
      access_key   = sensitive(var.storage_account.access_key)
      account_name = var.storage_account.account_name
      name         = var.storage_account.name
      share_name   = var.storage_account.share_name
      type         = var.storage_account.type
      mount_path   = var.storage_account.mount_path
    }
  }
}
# Create diagnostic settings WebApp
resource "azurerm_monitor_diagnostic_setting" "vault" {
  count                      = var.diagnostic_setting != null ? 1 : 0
  name                       = var.diagnostic_setting.diagnostic_setting_name
  target_resource_id         = azurerm_windows_web_app.webapp.id
  storage_account_id         = try(var.diagnostic_setting.storage_account_id, null) == null ? null : var.diagnostic_setting.storage_account_id
  log_analytics_workspace_id = var.diagnostic_setting.log_analytics_workspace_id

  dynamic "log" {
    for_each = { for logs in var.diagnostic_setting.log : logs.category => logs }
    content {
      category = log.value.category
      enabled  = log.value.enabled
      retention_policy {
        enabled = log.value.retention_policy.enabled
        days    = log.value.retention_policy.enabled == true ? try(log.value.retention_policy.days, null) : null
      }
    }
  }

  dynamic "metric" {
    for_each = { for metrics in var.diagnostic_setting.metric : metrics.category => metrics }
    content {
      category = metric.value.category
      enabled  = metric.value.enabled
      retention_policy {
        enabled = metric.value.retention_policy.enabled
        days    = metric.value.retention_policy.enabled == true ? try(metric.value.retention_policy.days, null) : null
      }
    }
  }
}
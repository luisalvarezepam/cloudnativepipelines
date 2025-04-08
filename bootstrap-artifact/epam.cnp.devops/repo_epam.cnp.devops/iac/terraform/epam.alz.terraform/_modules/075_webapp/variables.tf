variable "linux_webapp" {
  description = "Lixux web applications parameters"
  type        = any
  default     = []
}

variable "windows_webapp" {
  description = "Windows web applications parameters"
  type        = any
  default     = []
}

variable "default_site_config" {
  description = "Default site parameters"
  type        = any
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
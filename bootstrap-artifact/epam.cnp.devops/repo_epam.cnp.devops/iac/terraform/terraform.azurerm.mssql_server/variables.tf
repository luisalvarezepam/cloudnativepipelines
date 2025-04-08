variable "server_name" {
  type        = string
  description = "The name of the Microsoft SQL Server. This needs to be globally unique within Azure."
}
variable "rg_name" {
  type        = string
  description = "The name of the resource group in which to create the Microsoft SQL Server."
}
variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists.  If the parameter is not specified in the configuration file, the location of the resource group is used."
  default     = null
}
variable "server_version" {
  type        = string
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  default     = "12.0"
}
variable "administrator_login" {
  type        = string
  sensitive   = true
  description = "The administrator login name for the new server. Changing this forces a new resource to be created."
}

variable "administrator_password" {
  type        = string
  sensitive   = true
  description = "The password associated with the `administrator_login` user. Needs to comply with `Azure's Password Policy`."
  default     = null
}
variable "minimum_tls_version" {
  type        = string
  description = " The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2."
  default     = "1.2"
}
variable "vnet" {
  type = list(object({
    vnet_rg_name = string
    vnet_name    = string
    subnet_name  = string
  }))
  description = <<EOF

    The list of objects that include values:

    `subnet_name`  - the subnet name from which the SQL server will accept communications exists
    `vnet_name`    - the VNET name where subnet from which the SQL server will accept communications exists
    `vnet_rg_name` - the resource group name where VNET exists
    EOF
  default     = []
}
variable "firewall_rules" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = <<EOF

    The list of objects for MSSQL firewall rules configuration.

    `name`             - the name of the firewall rule
    `start_ip_address` - the starting IP address to allow through the firewall for this rule
    `end_ip_address`   - the ending IP address to allow through the firewall for this rule
    EOF
  default     = []
}
variable "kv" {
  type        = map(string)
  description = <<EOF
    The map that may consists of key vault name and key vault resource group name for retrieving administrator password from key vault.
    It is possible to exclude key vault resource groupe name if key vault and mssql server are in the same resource group. 
    Required if `administrator_password` is `null`.

    `kv_name`    - the key vault name where administrator password stored as a secret
    `kv_rg_name` - the resource group name where the key vault exists  
   EOF
  default     = null

}
variable "auditing_policy" {
  type = object({
    storage_name                            = string
    storage_rg_name                         = string
    retention_in_days                       = number
    storage_account_access_key_is_secondary = bool
  })
  description = <<EOF
    The object for MSSQL server extended auditing policy configuration.
    `storage_name`                            - the storage account name
    `storage_rg_name`                         - the resource group name where storage account exists
    `storage_account_access_key_is_secondary` - Specifies whether storage_account_access_key value is the storage's secondary key.
                                                Possible values are `true` or `false`
    `retention_in_days`                       - Specifies the number of days to retain logs for in the storage account.
    EOF
  default     = null
}
variable "connection_policy" {
  type        = string
  description = "The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default"
  default     = "Default"
}
variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for this server."
  default     = false
}
variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
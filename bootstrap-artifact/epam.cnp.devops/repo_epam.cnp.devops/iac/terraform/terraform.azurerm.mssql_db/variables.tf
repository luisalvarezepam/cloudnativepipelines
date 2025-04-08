variable "db_name" {
  type        = string
  description = "The name of the Ms SQL Database"
}
variable "mssql_server_id" {
  type        = string
  description = "The id of the Ms SQL Server on which to create the database."
}
variable "collation" {
  type        = string
  description = "Specifies the collation of the database."
  default     = null
}
variable "license_type" {
  type        = string
  description = "Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice"
  default     = "LicenseIncluded"
}
variable "max_size_gb" {
  type        = number
  description = "The max size of the database in gigabytes."
  default     = 4
}
variable "read_scale" {
  type        = bool
  description = "If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
  default     = false
}
variable "sku_name" {
  type        = string
  description = "Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100"
  default     = "Basic"
}
variable "zone_redundant" {
  type        = bool
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones."
  default     = false
}
variable "auditing_policy" {
  type = object({
    retention_in_days                       = number
    storage_account_access_key_is_secondary = bool
  })
  description = <<EOF
    The object for MSSQL database extended auditing policy configuration.

    `storage_account_access_key_is_secondary` - Specifies whether storage_account_access_key value is the storage's secondary key.
                                                Possible values are `true` or `false`
    
    `retention_in_days`                       - Specifies the number of days to retain logs for in the storage account.
    EOF
  default     = null
}
variable "storage_account" {
  type        = map(string)
  description = <<EOF

    The map that may consists of storage account name, storage account resource group name,for MSSQL database 
    extended auditing policy configuration.

    `storage_name`                            - the storage account name
    `storage_rg_name`                         - the resource group name where storage account exists

    EOF
  default     = null
}
variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
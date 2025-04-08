variable "name" {
  description = "Specifies the name of the Shared Dashboard."
  type        = string
}

variable "rg_name" {
  description = <<EOF
  The name of the resource group in which to create the appinsight. Changing this forces a new 
  resource to be created.
  EOF
  type        = string
}

variable "location" {
  description = <<EOT
  Specifies the supported Azure location where the resource exists.
  If the parameter is not specified in the configuration file, the location of the resource group is used.
  EOT
  type        = string
  default     = null
}

variable "config_file_name" {
  description = <<EOT
   The name of the file containing the dashboard configuration in JSON format It is recommended to follow the steps
   outlined [here](https://learn.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards-create-programmatically#fetch-the-json-representation-of-the-dashboard) to create a Dashboard in the Portal and extract the relevant JSON to use in this resource.
   From the extracted JSON, the contents of the properties: {} object can used. 
  EOT
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
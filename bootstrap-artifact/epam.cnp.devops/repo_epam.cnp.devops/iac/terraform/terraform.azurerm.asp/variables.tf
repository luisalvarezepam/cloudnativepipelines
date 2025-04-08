variable "name" {
  description = "Specifies the name of the App Service Plan. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Specifies the location of the App Service Plan. Changing this forces a new resource to be created."
  type        = string
}

variable "rg_name" {
  description = "The name of the Resource group"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The SKU for the plan"
  type        = string
}

variable "os_type" {
  description = "The O/S type for the App Services to be hosted in this plan"
  type        = string
  default     = "Linux"
}

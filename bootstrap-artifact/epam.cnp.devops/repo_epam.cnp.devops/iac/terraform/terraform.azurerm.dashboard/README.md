# terraform.azurerm.dashboard

This module deploys an dashboards.

## Prerequisites

| Resource name | Required | Description |
|---------------|----------|-------------|
| resource group        | yes   |        |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.31.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_portal_dashboard.my-board](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/portal_dashboard) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |



## Usage example

```go
module "dashboard" {
  source = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.dashboard?ref=v1.0.0"

  name             = "example-name"
  rg_name          = "example-rg-name"
  location         = "northeurope"
  config_file_name = "example-name.tpl"

  tags = {
    environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_file_name"></a> [config\_file\_name](#input\_config\_file\_name) | The name of the file containing the dashboard configuration in JSON format It is recommended to follow the steps<br>   outlined [here](https://learn.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards-create-programmatically#fetch-the-json-representation-of-the-dashboard) to create a Dashboard in the Portal and extract the relevant JSON to use in this resource.<br>   From the extracted JSON, the contents of the properties: {} object can used. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists.<br>  If the parameter is not specified in the configuration file, the location of the resource group is used. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Specifies the name of the Shared Dashboard. | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group in which to create the appinsight. Changing this forces a new <br>  resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dashboard. |
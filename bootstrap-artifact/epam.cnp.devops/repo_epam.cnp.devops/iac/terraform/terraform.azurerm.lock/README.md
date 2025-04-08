# terraform.azurerm.lock

This module creates an Azure management lock on a specified resource.

## Prerequisites

| Resource name         | Required  | Description                                               |
|-----------------------|-----------|-----------------------------------------------------------|
| Any other resource    | yes       | to be locked                                              |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |



## Usage example

```go
module "lock" {
  source = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.lock?ref=v1.3.0"

  resource_id = "/subscriptions/12345678-12234-5678-9012-123456789012/resourceGroups/example-rg"
  lock_name   = "example-lock"
  lock_level  = "CanNotDelete"
  notes       = "example note"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lock_level"></a> [lock\_level](#input\_lock\_level) | Specifies the Level to be used for this Lock. Changing this forces a new resource to be created | `string` | `"CanNotDelete"` | no |
| <a name="input_lock_name"></a> [lock\_name](#input\_lock\_name) | Specifies the name of the Management Lock. Changing this forces a new resource to be created | `string` | n/a | yes |
| <a name="input_notes"></a> [notes](#input\_notes) | Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created | `string` | `null` | no |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | The id of the locked Resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lock_id"></a> [lock\_id](#output\_lock\_id) | The ID of the Management Lock |
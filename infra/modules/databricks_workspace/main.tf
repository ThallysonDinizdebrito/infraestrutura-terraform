variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}

resource "azurerm_databricks_workspace" "dbw" {
  name                = "${var.name_prefix}-dbw"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "standard"
}
variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

variable "name_prefix" {
  type = string
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.name_prefix}sa"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "raw" {
  name                  = "raw"
  storage_account_id = azurerm_storage_account.sa.id
  container_access_type = "private"
}
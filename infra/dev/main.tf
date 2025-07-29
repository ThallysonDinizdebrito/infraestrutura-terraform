provider "azurerm" {
  features {}
  subscription_id = "5c749e4a-06c8-42fc-992f-a1cd9d736563"
}

module "resource_group" {
  source      = "../modules/resource_group"
  name        = var.project_name
  location    = var.location
}

module "storage_account" {
  source         = "../modules/storage_account"
  resource_group = module.resource_group.name
  location       = var.location
  name_prefix    = "projdados"  # <-- SEM traço
}


module "databricks_workspace" {
  source         = "../modules/databricks_workspace"
  resource_group = module.resource_group.name
  location       = var.location
  name_prefix    = var.project_name
}

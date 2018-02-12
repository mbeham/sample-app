provider "azurerm" {

}

terraform {
  backend "azurerm" {
    resource_group_name = "jambitiac"
    storage_account_name = "jambitiac"
    container_name       = "tfstate"
  }
}

resource "azurerm_resource_group" "sample_app" {
  name     = "rg_${ var.user }_sample_app"
  location = "${ var.location }"
}

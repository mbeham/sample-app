provider "azurerm" {

}

terraform {
  backend "azurerm" {
    storage_account_name = "jambitiac"
    container_name       = "tfstate"
    key                  = "${ var.user }.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "sample_app" {
  name     = "rg_${ var.user }_sample_app"
  location = "${ var.location }"
}

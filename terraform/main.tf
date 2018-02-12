provider "azurerm" {

}

resource "azurerm_resource_group" "sample_app" {
  name     = "rg_${ var.user }_sample_app"
  location = "${ var.location }"
}

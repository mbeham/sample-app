provider "azurerm" {

}

resource "azurerm_resource_group" "test" {
  name     = "test"
  location = "westeurope"
}

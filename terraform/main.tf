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

data "azurerm_image" "sample_app" {
  name                = "1518428281"
  resource_group_name = "jambitiac"
}

resource "azurerm_public_ip" "sample_app" {
  name                         = "sample_app_pip"
  location                     = "${ var.location }"
  resource_group_name          = "${azurerm_resource_group.sample_app.name}"
  public_ip_address_allocation = "static"
  domain_name_label = "${ var.user }-host"
}

resource "azurerm_virtual_network" "sample_app" {
  name                = "sample_app_vn"
  address_space       = ["10.0.0.0/16"]
  location            = "${ var.location }"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"
}

resource "azurerm_subnet" "sample_app" {
  name                 = "sample_app_sub"
  resource_group_name  = "${azurerm_resource_group.sample_app.name}"
  virtual_network_name = "${azurerm_virtual_network.sample_app.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "sample_app" {
  name                = "sample_app_ni"
  location            = "${ var.location }"
  resource_group_name = "${azurerm_resource_group.sample_app.name}"

  ip_configuration {
    name                          = "sampleappconfiguration1"
    subnet_id                     = "${azurerm_subnet.sample_app.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.sample_app.id}"
  }
}

resource "azurerm_virtual_machine" "sample_app" {
  name                  = "sample_app_vm"
  location              = "${ var.location }"
  resource_group_name   = "${azurerm_resource_group.sample_app.name}"
  network_interface_ids = ["${azurerm_network_interface.sample_app.id}"]
  vm_size               = "Standard_A1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.sample_app.id}"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${ var.user }-host"
    admin_username = "${ var.user }"
    admin_password = "${ var.password }"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

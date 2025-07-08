# data "azurerm_public_ip" "public_ip" {
#   name                = var.frontend_ip_name
#   resource_group_name = var.resource_group_name
# }

# data "azurerm_subnet" "frontend_subnet" {
#   name                = var.frontend_subnet_name
#   resource_group_name = var.resource_group_name
#   virtual_network_name = var.vnet_name
# }

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    public_ip_address_id = data.azurerm_public_ip.public_ip.id
    # public_ip_address_id  = "/subscriptions/3fed4955-0ed0-4498-a979-f538b3d003fa/resourceGroups/zee_rg/providers/Microsoft.Network/publicIPAddresses/zee_public_ip"
    name                 = "internal" 
    subnet_id            = data.azurerm_subnet.frontend_subnet.id
    # subnet_id            = "/subscriptions/3fed4955-0ed0-4498-a979-f538b3d003fa/resourceGroups/zee_rg/providers/Microsoft.Network/virtualNetworks/zee_vnet/subnets/Frontend_subnet"
    private_ip_address_allocation = "Dynamic"
  }

}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  # computer_name  = "computer"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}


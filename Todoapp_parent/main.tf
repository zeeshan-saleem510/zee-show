module "resource_group" {
  source                  = "../modules/azurerm_resource_group"
  resource_group_name     = "zee_rg"
  resource_group_location = "centralindia"
}

module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../modules/azurerm_virtual_network"
  resource_group_name      = "zee_rg"
  virtual_network_location = "central india"
  virtual_network_name     = "zee_vnet"
  address_space            = ["10.0.0.0/16"]
}
module "Frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "zee_rg"
  virtual_network_name = "zee_vnet"
  subnet_name          = "Frontend_subnet"
  address_prefixes     = ["10.0.1.0/24"]

}

# module "Backend_subnet" {
#   depends_on           = [module.virtual_network]
#   source               = "../modules/azurerm_subnet"
#   resource_group_name  = "zee_rg"
#   virtual_network_name = "zee_vnet"
#   subnet_name          = "Backend_subnet"
#   address_prefixes     = ["10.0.2.0/24"]
# }

module "public_ip" {
  depends_on              = [module.Frontend_subnet]
  source                  = "../modules/azurerm_public_ip"
  public_ip_name          = "zee_public_ip"
  resource_group_name     = "zee_rg"
  resource_group_location = "central india"
  allocation_method       = "Static"
}

module "frontend_vm" {
  depends_on = [module.Frontend_subnet, module.public_ip]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name  = "zee_rg"
  location             = "central india"
  vm_name              = "vm_frontend"
  vm_size              = "Standard_B1s"
  admin_username       = "zeeadmin"
  admin_password       = "Mansoor@1234" # Ensure this password meets Azure's complexity requirements  
  image_publisher      = "Canonical"
  image_offer          = "ubuntuserver"
  image_sku            = "18.04-LTS"
  image_version        = "latest"
  nic_name             = "nic-frontend"
  frontend_ip_name     = "zee_public_ip"
  frontend_subnet_name = "Frontend_subnet"
  vnet_name            = "zee_vnet"
  # subnet_id            = data.azurerm_subnet.Frontend_subnet.id
  # pip_id               = data.azurerm_public_ip.public_ip.id

  # pip_id    = "/subscriptions/3fed4955-0ed0-4498-a979-f538b3d003fa/resourceGroups/zee_rg/providers/Microsoft.Network/publicIPAddresses/zee_public_ip"
  # subnet_id = "/subscriptions/3fed4955-0ed0-4498-a979-f538b3d003fa/resourceGroups/zee_rg/providers/Microsoft.Network/virtualNetworks/zee_vnet/subnets/Frontend_subnet"
}

# data "azurerm_public_ip" "public_ip" {
#   pip_name = "zee_public_ip"
#   resource_group_name = "zee_rg"
# }

# data "azurerm_subnet" "frontend_subnet" {
#   subnet_name = "Frontend_subnet"
#   resource_group_name = "zee_rg"
#   virtual_network_name = "zee_vnet"
# }

# module "backend_vm" {
#   depends_on               = [module.Backend_subnet]
#   source                   = "../modules/azurerm_virtual_machine"

#   resource_group_name      = "zee_rg"
#   location = "central india"
#   vm_name = "vm_backend"
#   vm_size                  = "Standard_B1s"
#   admin_username           = "zeeadmin"
#   admin_password           = "Mansoor@1234" # Ensure this password meets Azure's complexity requirements  
#   image_publisher = "Canonical"
#   image_offer = "0001-com-ubuntu-server-focal"
#   image_sku = "20.04-LTS" 
#   image_version = "latest"  
#   nic_name = "nic-backend"
#   subnet_id = module.Backend_subnet.subnet_id
#   # PIP_id = module.public_ip.public_ip_id
# }

# module "sql_server" {
#   depends_on               = [module.Backend_subnet]
#   source                   = "../modules/azurerm_sql_server"
#   sql_server_name          = "zee-sql-server"
#   resource_group_name      = "zee_rg"
#   location                 = "central india"
#   # secret ka rakhne ka sudhar
#   administrator_login      = "sqladmin"
#   administrator_login_password = "Mansoor@1234" # Ensure this password meets Azure's complexity requirements
# }

# module "sql_database" {
#   depends_on               = [module.sql_server]
#   source                   = "../modules/azurerm_sql_database"
#   sql_database_name        = "zee-sql-database"
#   sql_server_id            = module.sql_server.sql_server_id
# }


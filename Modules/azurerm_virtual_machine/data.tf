data "azurerm_public_ip" "public_ip" {
  name                = var.frontend_ip_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "frontend_subnet" {
  name                = var.frontend_subnet_name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
}

# data "azurerm_key_vault" "key_vault" {
#   name                = zeeadmin
#   resource_group_name = "zee-key_vault"
# }   

# data "azurerm_key_vault_secret" "vm_username" {
#   name         = "vm_username"
#   key_vault_id = data.azurerm.key_vault.key_vault.id
# }

# data "azurerm_key_vault_secret" "vm_password" {
#   name         = "vm_password"
#   key_vault_id = data.azurerm.key_vault.key_vault.id
# }   
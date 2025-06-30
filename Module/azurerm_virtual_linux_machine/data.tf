data "azurerm_subnet" "sub_net" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}
data "azurerm_public_ip" "publicip" {
  name                = var.publicip_name
  resource_group_name =  var.resource_group_name
}
data "azurerm_key_vault" "keyvault_data" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
data "azurerm_key_vault_secret" "username" {
  name         = var.vm_username_secret_name
  key_vault_id = data.azurerm_key_vault.keyvault_data.id
}
data "azurerm_key_vault_secret" "password" {
  name         = var.vm_password_secret_name
  key_vault_id = data.azurerm_key_vault.keyvault_data.id
}

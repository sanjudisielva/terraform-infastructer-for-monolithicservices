data "azurerm_key_vault_secret" "datausername" {
  name         = var.mssqlserver_username_secret_name
  key_vault_id = data.azurerm_key_vault.keyvault_data.id
}
data "azurerm_key_vault_secret" "datapassword" {
  name         = var.mssqlserver-password_secret_name
  key_vault_id = data.azurerm_key_vault.keyvault_data.id
}
data "azurerm_key_vault" "keyvault_data" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}
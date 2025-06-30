
# -----------------------------------------------------------------------------
# Key Features:
# - Azure Resource Group, Virtual Network, aur Subnets ka creation
# - Frontend ke liye Linux Virtual Machine with Public IP provisioning
# - Backend ke liye Azure SQL Server aur Database setup
# - Azure Key Vault ke through secrets (jaise VM aur SQL credentials) ka secure management
# - Sabhi resources reusable Terraform modules ke through manage kiye ja rahe hain
#
# Is folder ko use karke aap apne TodoApp ke liye ek secure, scalable, aur production-ready
# Azure infrastructure automate kar sakte hain. Sabhi modules aur secrets centralized hain,
# jisse management aur security dono easy ho jati hai.


module "rg" {
  source                  = "../module/azurerm_resource_group"
  resource_group_name     = "my_todorg"
  resource_group_location ="centralindia"
}
module "virtualnetwork" {
  source                  = "../module/azurerm_virtual_network"
  depends_on              = [module.rg]
  virtual_network_name    = "sanjuvnet"
  resource_group_location = "centralindia"
  resource_group_name     = "my_todorg"
  address_space           = ["10.0.0.0/16"]
}

module "subnet_frontend" {
  source               = "../module/azurerm_subnet"
  depends_on           = [module.virtualnetwork]
  subnet_name          = "frontend_subnet"
  resource_group_name  = "my_todorg"
  virtual_network_name = "sanjuvnet"
  address_prefixes     = ["10.0.1.0/24"]
}
module "subnet_backend" {
  source               = "../module/azurerm_subnet"
  depends_on           = [module.virtualnetwork]
  subnet_name          = "backend_subnet"
  resource_group_name  = "my_todorg"
  virtual_network_name = "sanjuvnet"
  address_prefixes     = ["10.0.2.0/24"]
}
module "pip" {
  source                  = "../module/azurerm_public_ip"
  depends_on              = [module.subnet_frontend]
  publicip_name           = "frontend_pip"
  resource_group_name     = "my_todorg"
  resource_group_location = "centralindia"
  allocation_method       = "Static"
}


module "frontend_vm" {
  source                  = "../module/azurerm_virtual_linux_machine"
  depends_on              = [module.virtualnetwork, module.key_vault, module.pip, module.secret_password, module.secret_username]
  nic_name                = "frontend_nic"
  resource_group_location = "centralindia"
  resource_group_name     = "my_todorg"
  subnet_name             = "frontend_subnet"
  virtual_network_name    = "sanjuvnet"
  publicip_name           = "frontend_pip"
  virtual_machine_name    = "frontendvirtual-machine"
  vm_size                 = "Standard_F2"
  vm_username             = "vm_userid"
  vm_admin_password       = "vm_password"
  image_publisher         = "Canonical"
  image_offer             = "0001-com-ubuntu-server-jammy"
  image_sku               = "22_04-lts"
  image_version           = "latest"
  key_vault_name          = "harshia-keyvault"
  vm_username_secret_name = "vm-username"
  vm_password_secret_name = "vm-password"
}
module "mssqlserver" {
  source                           = "../module/azurerm_data_server"
  depends_on                       = [module.key_vault, module.rg, module.secret_sql_data_username, module.secret_sql_data_password]
  mssql_server_name                = "mssqltodoapp"
  resource_group_location          = "centralindia"
  resource_group_name              = "my_todorg"
  key_vault_name                   = "harshia-keyvault"
  mssqlserver_username_secret_name = "sqldtausername"
  mssqlserver-password_secret_name = "sqldatapassword"

}
module "mssql_database" {
  depends_on          = [module.rg, module.mssqlserver]
  source              = "../Module/azurerm_sql_data"
  mssql_database_name = "todo-mssqldatabase"
  resource_group_name = "my_todorg"
  mssql_server_name   = "mssqltodoapp"


}
module "key_vault" {
  depends_on              = [module.rg]
  source                  = "../module/azurerm_key_vault"
  key_vault_name          = "harshia-keyvault"
  resource_group_location = "centralindia"
  resource_group_name     = "my_todorg"
}
module "secret_username" {
  depends_on          = [module.key_vault, module.rg]
  source              = "../module/azurerm_key_vault_secret"
  secret_name         = "vm-username"
  secret_value        = "sanjuadmin"
  key_vault_name      = "harshia-keyvault"
  resource_group_name = "my_todorg"
}
module "secret_password" {
  depends_on          = [module.key_vault, module.rg]
  source              = "../module/azurerm_key_vault_secret"
  secret_name         = "vm-password"
  secret_value        = "Sanju@1234567"
  key_vault_name      = "harshia-keyvault"
  resource_group_name = "my_todorg"
}
module "secret_sql_data_username" {
  depends_on          = [module.key_vault, module.rg]
  source              = "../module/azurerm_key_vault_secret"
  secret_name         = "sqldtausername"
  secret_value        = "sqldatausername"
  key_vault_name      = "harshia-keyvault"
  resource_group_name = "my_todorg"
}
module "secret_sql_data_password" {
  depends_on          = [module.key_vault, module.rg]
  source              = "../module/azurerm_key_vault_secret"
  secret_name         = "sqldatapassword"
  secret_value        = "Sanju7654321"
  key_vault_name      = "harshia-keyvault"
  resource_group_name = "my_todorg"
}

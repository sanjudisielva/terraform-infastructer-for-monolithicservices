data "azurerm_mssql_server" "dataserver" {
  name                = var.mssql_server_name
  resource_group_name =var.resource_group_name
}
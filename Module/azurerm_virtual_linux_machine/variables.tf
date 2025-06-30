variable "nic_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "virtual_network_name" {
  type = string
}
variable "publicip_name" {
  type = string
}
variable "virtual_machine_name" {
  type = string
}
variable "vm_size"{
    type = string
}
variable "vm_username" {
  type = string
}
variable "vm_admin_password" {
  type = string
}
variable "image_publisher" {
  type = string
}
variable "image_offer" {
  type = string
}
variable "image_sku" {
  type = string
}
variable "image_version" {
  type = string
}
variable "key_vault_name" {
  type = string
}
variable "vm_password_secret_name" {
  type = string
}
variable "vm_username_secret_name" {
  type = string
}
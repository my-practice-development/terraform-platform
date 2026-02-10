provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "hub_net" {
  name     = "rg-hub-net-dev"
  location = "westeurope"
}

resource "azurerm_resource_group" "hub_mon" {
  name     = "rg-hub-mon-dev"
  location = "westeurope"
}

module "hub_vnet" {
  source              = "git::https://github.com/my-practice-development/terraform-modules.git//network/vnet"
  name                = "vnet-hub-dev"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.hub_net.name
  address_space       = ["10.0.0.0/16"]
}

module "hub_subnet_shared" {
  source              = "git::https://github.com/my-practice-development/terraform-modules.git//network/subnet"
  name                = "snet-shared"
  resource_group_name = azurerm_resource_group.hub_net.name
  vnet_name           = module.hub_vnet.name
  address_prefixes    = ["10.0.1.0/24"]
}

module "log_analytics" {
  source              = "git::https://github.com/my-practice-development/terraform-modules.git//monitoring/log-analytics"
  name                = "law-hub-dev"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.hub_mon.name
}

output "hub_vnet_id" {
  value = module.hub_vnet.id
}

output "hub_vnet_name" {
  value = module.hub_vnet.name
}

output "hub_rg_name" {
  value = azurerm_resource_group.hub_net.name
}

output "log_analytics_id" {
  value = module.log_analytics.id
}

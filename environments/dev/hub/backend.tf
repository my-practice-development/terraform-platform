terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateXXXX"
    container_name       = "platform-dev"
    key                  = "hub.tfstate"
  }
}

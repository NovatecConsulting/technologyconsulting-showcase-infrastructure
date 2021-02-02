terraform {
  backend "azurerm" {
    container_name       = "terraformstate"
  }
}

provider "azurerm" {
    features {}
}

variable "environment" { }
variable "firefighterName" { }

module "platform" {
  source               = "./modules"
  environment          = var.environment
  location             = "westeurope"
  firefighterName      = var.firefighterName
}

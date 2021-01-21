terraform {
  backend "azurerm" {
    container_name       = "terraformstate"
  }
}
provider "azurerm" {
    features {}
}

variable "environment" { }
variable "developergroup" { }
variable "spigroup" { }

module "platform" {
  source               = "./modules"
  environment          = var.environment
  location             = "westeurope"
  developergroup       = var.developergroup
  spigroup             = var.spigroup
}





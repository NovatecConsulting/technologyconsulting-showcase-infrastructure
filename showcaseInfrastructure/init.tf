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
variable "vpc_adress_space" {}

module "platform" {
  source               = "./modules"
  environment          = var.environment
  location             = "westeurope"
  developergroup       = var.developergroup
  spigroup             = var.spigroup
  vpc_adress_space     = [var.vpc_adress_space]
}





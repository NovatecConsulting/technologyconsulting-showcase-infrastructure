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
variable "appdynamics_url" {}
variable "appdynamics_account" {}
variable "appdynamics_username" {}
variable "appdynamics_password" {}
variable "appdynamics_accessKey"{}


module "platform" {
  source                = "./modules"
  environment           = var.environment
  location              = "westeurope"
  developergroup        = var.developergroup
  spigroup              = var.spigroup
  vpc_adress_space      = [var.vpc_adress_space]
  appdynamics_url       = var.appdynamics_url
  appdynamics_account   = var.appdynamics_account
  appdynamics_username  = var.appdynamics_username
  appdynamics_password  = var.appdynamics_password
  appdynamics_accessKey = var.appdynamics_accessKey
}





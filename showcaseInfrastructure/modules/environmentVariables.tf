data "azurerm_client_config" "current" { }

variable "location" { }

variable "environment" { }

variable "spigroup" { }

variable "developergroup" { }

variable "vpc_adress_space" { }

variable "appdynamics_account" { }

variable "appdynamics_username" { }

variable "appdynamics_password" { }

variable "appdynamics_accessKey" { }

variable "appdynamics_url" {}


locals {
  stages = [
    "dev",
    "stag",
    "prod"
  ]
}

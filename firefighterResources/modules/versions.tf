terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.73.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }

    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
  required_version = ">= 0.13"
}

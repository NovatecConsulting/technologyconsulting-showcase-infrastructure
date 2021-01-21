data "azurerm_client_config" "current" {
    # lookup for azure resource manager's config
}

variable "location" {
    # will be provided as environment variable.
}

variable "environment" {
    # will be provided as environment variable.
}

variable "spigroup" {
    # will be provided as environment variable.
}

variable "developergroup" {
    # will be provided as environment variable.
}
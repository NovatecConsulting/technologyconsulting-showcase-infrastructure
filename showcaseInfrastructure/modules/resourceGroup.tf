resource "azurerm_resource_group" "resourceGroup" {
        name = "tc-showcase-${var.environment}"
        location = var.location
}

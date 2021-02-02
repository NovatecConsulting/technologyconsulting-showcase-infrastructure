data "azurerm_container_registry" "containerregistry" {
  name                = "nttcshowcase"
  resource_group_name = "tc-showcase-common"
}

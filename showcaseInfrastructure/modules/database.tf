
resource "random_string" "dbPasswordGen" {
  length  = 127
  upper   = true
  lower   = true
  number  = true
  special = false
}

resource "azurerm_postgresql_server" "pgdatabaseserver" {
    name                = "tc-showcase-${var.environment}-psql"
    location            = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name

    sku_name = "B_Gen5_2"

    storage_mb                       = 5120
    backup_retention_days            = 7
    geo_redundant_backup_enabled     = false
    auto_grow_enabled                = true
    public_network_access_enabled    = true
    administrator_login              = "ntservice"
    administrator_login_password     = random_string.dbPasswordGen.result
    version                          = "11"
    ssl_enforcement_enabled          = true
}

resource "azurerm_postgresql_database" "orderdomain_db" {
    for_each = toset(local.stages)  
    name                = "order_db-${each.key}"
    resource_group_name = azurerm_resource_group.resourceGroup.name
    server_name         = azurerm_postgresql_server.pgdatabaseserver.name
    charset             = "UTF8"
    collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "manufacturedomain_db" {
    for_each = toset(local.stages)  
    name                = "manufacture_db-${each.key}"
    resource_group_name = azurerm_resource_group.resourceGroup.name
    server_name         = azurerm_postgresql_server.pgdatabaseserver.name
    charset             = "UTF8"
    collation           = "English_United States.1252"
}

resource "azurerm_postgresql_database" "supplierdomain_db" {
    for_each = toset(local.stages)  
    name                = "supplier_db-${each.key}"
    resource_group_name = azurerm_resource_group.resourceGroup.name
    server_name         = azurerm_postgresql_server.pgdatabaseserver.name
    charset             = "UTF8"
    collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "pgdatabaseserverfirewallallow" {
    name                = "allowall"
    resource_group_name = azurerm_resource_group.resourceGroup.name
    server_name         = azurerm_postgresql_server.pgdatabaseserver.name
    start_ip_address    = "0.0.0.0"
    end_ip_address      = "255.255.255.255"
}

resource "azurerm_key_vault_secret" "azurekeyvaultpgdatabasepw_password" {
  name         = "database-password"
  value        = random_string.dbPasswordGen.result
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "azurekeyvaultpgdatabasepw_user" {
  name         = "database-user"
  value        = "${azurerm_postgresql_server.pgdatabaseserver.administrator_login}@${azurerm_postgresql_server.pgdatabaseserver.name}"
  key_vault_id = azurerm_key_vault.vault.id
}


resource "azurerm_key_vault_secret" "azurekeyvaultpgdatabase_fqdn" {
  name         = "database-fqdn"
  value        = azurerm_postgresql_server.pgdatabaseserver.fqdn
  key_vault_id = azurerm_key_vault.vault.id
}

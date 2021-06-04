

resource "azurerm_cosmosdb_account" "dbaccount" {
  name                = "cosmos-dbaccount"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  enable_free_tier = true
  enable_automatic_failover = false

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = azurerm_resource_group.resourceGroup.location
    failover_priority = 0
  }

  
}



resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  name                = "cosmos-mongo-database"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  account_name        = azurerm_cosmosdb_account.dbaccount.name
  throughput          = 400
}
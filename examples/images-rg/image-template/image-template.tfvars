resource_group_name         = "images"
location                    = "eastus"
image_builder_template_path = "../../azure/terraform/arm-templates/windowsImageTemplate.json"
image_template_name         = "win2016-sql2017web"
user_assigned_identity_name = "image-builder"
gallery_name                = "imggal"
gallery_image_name          = "win2016-sql2017web"
source_image_publisher      = "MicrosoftSQLServer"
source_image_offer          = "SQL2017-WS2016"
source_image_sku            = "Web"
artifact_tags = {
  "source" : "azureVmImageBuilder",
  "baseosimg" : "windows2016",
  "sqlversion" : "sql2017web"
}
replication_regions = ["eastus"]
tags                = {}

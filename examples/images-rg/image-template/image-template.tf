terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.90"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_user_assigned_identity" "images" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}

data "azurerm_shared_image" "images" {
  name                = var.gallery_image_name
  gallery_name        = var.gallery_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_resource_group_template_deployment" "images" {
  name                = "win2016-sql2017web"
  resource_group_name = var.resource_group_name
  template_content    = file(var.image_builder_template_path)
  parameters_content = jsonencode({
    "imageTemplateName" = {
      value = "win2016-sql2017web"
    },
    "location" = {
      value = var.location
    },
    "userAssignedIdentityId" = {
      value = data.azurerm_user_assigned_identity.images.id
    },
    "galleryImageId" = {
      value = data.azurerm_shared_image.images.id
    },
    "sourceImagePublisher" = {
      value = var.source_image_publisher
    },
    "sourceImageOffer" = {
      value = var.source_image_offer
    },
    "sourceImageSku" = {
      value = var.source_image_sku
    },
    "artifactTags" = {
      value = var.artifact_tags
    },
    "replicationRegions" = {
      value = var.replication_regions
    }
    "tags" = {
      value = var.tags
    }
  })
  deployment_mode = "Incremental"
}

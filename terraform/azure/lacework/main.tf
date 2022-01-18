terraform {
  required_providers {
    lacework = {
      source = "lacework/lacework"
      version = "~> 0.5"
    }
  }
}

provider "azuread" {}
provider "azurerm" {
  features {}
}

module "az_ad_application" {
  source  = "lacework/ad-application/azure"
  version = "~> 1.0"
}

provider "lacework" {
  account    = "lwintgabeobrien"
  api_key    = "LWINTGAB_9E34D5A091C93A24F03BCB434B11A0CBB184A3F085BFA98"
  api_secret = "_91e0047bb1bf2f56cda899dfc7ca2ca8"
}


module "az_config" {
  source  = "lacework/config/azure"
  version = "~> 1.0"

  use_existing_ad_application = true
  application_id              = module.az_ad_application.application_id
  application_password        = module.az_ad_application.application_password
  service_principal_id        = module.az_ad_application.service_principal_id
}

module "az_activity_log" {
  source  = "lacework/activity-log/azure"
  version = "~> 1.0"

  use_existing_ad_application = true
  application_id              = module.az_ad_application.application_id
  application_password        = module.az_ad_application.application_password
  service_principal_id        = module.az_ad_application.service_principal_id
}
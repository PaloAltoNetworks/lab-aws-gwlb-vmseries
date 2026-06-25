terraform {
  required_version = ">= 1.5, < 2.0"

  # State is kept LOCALLY in your (persistent) Azure Cloud Shell home directory.
  # That's fine here because Cloud Shell persists your files across sessions. If you
  # ever run this somewhere ephemeral, switch to a remote "azurerm" backend instead.

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

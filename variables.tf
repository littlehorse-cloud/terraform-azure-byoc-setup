variable "location" {
  type        = string
  default     = "East US"
  description = "The Azure region where resources will be created."
}

variable "repository_name" {
  description = "The name of the GitHub repository to be used for Azure AD App registration."
  type        = string
  validation {
    condition     = var.repository_name != null && var.repository_name != ""
    error_message = "The repository_name variable must not be null or empty."
  }
}

variable "organization_name" {
  description = "The name of the GitHub organization to be used for Azure AD App registration."
  type        = string
  validation {
    condition     = var.organization_name != null && var.organization_name != ""
    error_message = "The organization_name variable must not be null or empty."
  }
}

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
  validation {
    condition     = var.subscription_id != null && var.subscription_id != ""
    error_message = "The subscription_id variable must not be null or empty."
  }
}

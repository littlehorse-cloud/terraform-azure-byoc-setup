variable "location" {
  type        = string
  default     = "East US"
  description = "The Azure region where resources will be created."
}

variable "repository_name" {
  description = "The name of the GitHub repository to be used for Azure AD App registration."
  type        = string

}

variable "organization_name" {
  description = "The name of the GitHub organization to be used for Azure AD App registration."
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}

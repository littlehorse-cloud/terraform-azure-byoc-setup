locals {
  resource_group_name = "lh-byoc-resources"
  location            = var.location
  suffix              = substr(replace(var.subscription_id, "-", ""), 0, var.suffix_length)
}

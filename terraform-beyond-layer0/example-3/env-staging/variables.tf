variable "endpoint" {}

variable "token" {}

variable "access_key" {}

variable "secret_key" {}

variable "environment" {
  default = "staging"
}

variable "region" {
  default = "us-west-2"
}

# rather than add conditional statements to resources configurations
# creating a lookup table can be more useful
variable "service_scale" {
  type = "map"

  default = {
    "dev"     = "1"
    "staging" = "3"
  }
}

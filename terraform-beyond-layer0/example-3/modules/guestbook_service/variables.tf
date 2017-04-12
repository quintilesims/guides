#
# modules/guestbook_service/variables.tf
#

variable "name" {}

variable "environment" {}

variable "table_name" {
  default = "guestbook"
}

variable "access_key" {}

variable "secret_key" {}

variable "endpoint" {}

variable "token" {}

variable "region" {}

variable "service_scale" {
  type = "map"
}

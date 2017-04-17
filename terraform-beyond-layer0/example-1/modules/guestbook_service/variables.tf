#
# modules/guestbook_service/variables.tf
#

variable "name" {
  default = "guestbook"
}

variable "table_name" {
  default = "guestbook"
}

variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-west-2"
}

variable "layer0_environment_id" {}

variable "layer0_environment_name" {}

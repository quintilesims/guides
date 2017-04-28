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

variable "load_balancer_name" {
  description = "Name of Layer0 load balancer to create"
  default = "guestbook-lb"
}

variable "service_name" {
  description = "Name of Layer0 service to create"
  default = "guestbook-svc"
}

variable "deploy_name" {
  description = "Name of Layer0 deploy to create"
  default = "guestbook-dpl"
}

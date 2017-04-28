variable "name" {
  default = "guestbook"
}

variable "table_name" {
  default = "guestbook1"
}

variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-west-2"
}

variable "layer0_environment_id" {}

variable "layer0_environment_name" {}

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
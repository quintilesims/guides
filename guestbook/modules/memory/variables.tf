variable "environment_id" {
  description = "ID of the Layer0 environment to create the service"
}

variable "deploy_name" {
  description = "name to use for the deploy"
  default     = "guestbook"
}

variable "load_balancer_name" {
  description = "name to use for the load balancer"
  default     = "guestbook"
}

variable "service_name" {
  description = "name to use for the service"
  default     = "guestbook"
}

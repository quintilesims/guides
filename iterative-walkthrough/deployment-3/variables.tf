variable "endpoint" {
  description = "The endpoint for the layer0 api"
}

variable "token" {
  description = "The authentication token for the layer0 api"
}

variable "redis_consul_service_name" {
  default = "redis"
}

variable "guestbook_consul_service_name" {
  default = "guestbook"
}

variable "redis_port" {
  default = 6379
}

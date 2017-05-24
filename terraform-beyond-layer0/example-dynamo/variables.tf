variable "endpoint" {
  description = "The endpoint for the layer0 api"
}

variable "token" {
  description = "The authentication token for the layer0 api"
}

variable "access_key" {
  description = "access key to create the dynamodb table"
}

variable "secret_key" {
  description = "secret key to create the dynamodb table"
}

variable "region" {
  description = "region to place the dynamodb table"
  default     = "us-west-2"
}

variable "table_name" {
  description = "The name to use for the dyamodb table"
  default     = "guestbook"
}

variable "endpoint" {
  default = "https://l0-curiosity-api-861308534.us-west-2.elb.amazonaws.com"
}

variable "token" { }

variable "access_key" { }

variable "secret_key" { }

variable "region" { }

variable "table_name" {
  default = "guestbook"
}

# to add another environment, append the list variable with a new value
# e.g., "prod"
variable "environments" {
  type = "list"

  default = [
    "dev",
    "staging"
  ]
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

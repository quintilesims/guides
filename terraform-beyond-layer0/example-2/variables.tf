variable "endpoint" {}

variable "token" {}

variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-west-2"
}

variable "table_name" {
  default = "guestbook"
}

# to add another environment, append the map variable with a new value
# e.g., "2" = "prod"
variable "environments" {
  type = "map"

  default = {
    "0" = "dev"
    "1" = "staging"

    # "2" = "prod"
  }
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

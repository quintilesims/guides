provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

resource "layer0_environment" "demo" {
  name = "demo"
}

module "guestbook" {
  source         = "github.com/quintilesims/layer0-examples//guestbook/module"
  environment_id = "${layer0_environment.demo.id}"
  backend_type   = "memory"
}

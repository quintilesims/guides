variable "endpoint" {}

variable "token" {}

# Configure the Layer0 Provider
provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

# Create an environment named "demo"
resource "layer0_environment" "demo" {
  name = "demo"
}

# Create a load balancer named "guestbook" with port 80 exposed
resource "layer0_load_balancer" "guestbook" {
  name        = "guestbook"
  environment = "${layer0_environment.demo.id}"

  port {
    host_port      = 80
    container_port = 80
    protocol       = "http"
  }
}

# Create a service named "guestbook"
resource "layer0_service" "guestbook" {
  name          = "guestbook"
  environment   = "${layer0_environment.demo.id}"
  deploy        = "${layer0_deploy.guestbook.id}"
  load_balancer = "${layer0_load_balancer.guestbook.id}"
}

# Create a deploy named "guestbook"
resource "layer0_deploy" "guestbook" {
  name    = "guestbook"
  content = "${data.template_file.guestbook.rendered}"
}

# Template for the "guestbook" deploy
# See: https://www.terraform.io/docs/providers/template/d/file.html
data "template_file" "guestbook" {
  template = "${file("Guestbook.Dockerrun.aws.json")}"
}

# Show the load balancer's url as output
output "guestbook_url" {
  value = "${layer0_load_balancer.guestbook.url}"
}

provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# create one layer0 environment for each map value defined in variable 'environments'
resource "layer0_environment" "demo" {
  count = "${length(var.environments)}"

  name = "${lookup(var.environments, count.index)}_demo"
}

# create one loadbalancer for each map value defined in variable 'environments'
resource "layer0_load_balancer" "guestbook" {
  count = "${length(var.environments)}"

  name        = "${lookup(var.environments, count.index)}_guestbook_lb"
  environment = "${element(layer0_environment.demo.*.id, count.index)}"

  port {
    host_port      = 80
    container_port = 80
    protocol       = "http"
  }
}

# create a datasource for each map value defined in variable 'environments' which
# references a environment specific dynamodb table.
data "template_file" "guestbook" {
  count = "${length(var.environments)}"

  template = "${file("${path.module}/Dockerrun.aws.json")}"

  vars {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
    table_name = "${element(aws_dynamodb_table.guestbook.*.name, count.index)}"
  }
}

# create a deploy for each map value defined in variable 'environments' which references
# an environment specific deploy resource
resource "layer0_deploy" "guestbook" {
  count = "${length(var.environments)}"

  name    = "${element(layer0_environment.demo.*.name, count.index)}_guestbook_dpl"
  content = "${element(data.template_file.guestbook.*.rendered, count.index)}"
}

# create a layer0 service for each map value defined in variable 'environments' which 
# references an environment specific:
# - layer0 environment
# - deploy
# - load balancer
resource "layer0_service" "guestbook" {
  count = "${length(var.environments)}"

  name          = "${element(layer0_environment.demo.*.name, count.index)}_guestbook_svc"
  environment   = "${element(layer0_environment.demo.*.id, count.index)}"
  deploy        = "${element(layer0_deploy.guestbook.*.id, count.index)}"
  load_balancer = "${element(layer0_load_balancer.guestbook.*.id, count.index)}"

  # scale       = "${lookup(var.service_scale, lookup(var.environments, count.index), "1")}"
}

# create a dynamodb table for each map value defined in variable 'environments'
resource "aws_dynamodb_table" "guestbook" {
  count = "${length(var.environments)}"

  name           = "${lookup(var.environments, count.index)}_${var.table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

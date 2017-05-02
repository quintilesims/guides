provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

resource "layer0_environment" "demo" {
  name = "${var.environment}_demo"
}

resource "layer0_load_balancer" "guestbook" {
  name        = "${var.load_balancer_name}"
  environment = "${layer0_environment.demo.id}"

  port {
    host_port      = 80
    container_port = 80
    protocol       = "http"
  }
}

resource "layer0_service" "guestbook" {
  name          = "${var.service_name}"
  environment   = "${layer0_environment.demo.id}"
  deploy        = "${layer0_deploy.guestbook.id}"
  load_balancer = "${layer0_load_balancer.guestbook.id}"
  scale         = "${var.service_scale}"
}

resource "layer0_deploy" "guestbook" {
  name    = "${layer0_environment.demo.id}_${var.deploy_name}"
  content = "${data.template_file.guestbook.rendered}"
}

data "template_file" "guestbook" {
  template = "${file("${path.module}/Dockerrun.aws.json")}"

  vars {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
    table_name = "${aws_dynamodb_table.guestbook.name}"
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_dynamodb_table" "guestbook" {
  name           = "${var.environment}_${var.table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

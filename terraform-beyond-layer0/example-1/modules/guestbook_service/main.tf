#
# modules/guestbook_service/main.tf
#

resource "layer0_load_balancer" "guestbook" {
  name        = "${var.name}_guestbook_lb"
  environment = "${var.layer0_environment_id}"

  port {
    host_port      = 80
    container_port = 80
    protocol       = "http"
  }
}

resource "layer0_service" "guestbook" {
  name          = "${var.name}_guestbook_svc"
  environment   = "${var.layer0_environment_id}"
  deploy        = "${layer0_deploy.guestbook.id}"
  load_balancer = "${layer0_load_balancer.guestbook.id}"
}

resource "layer0_deploy" "guestbook" {
  name    = "${var.name}_guestbook_dpl"
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
  name           = "${var.layer0_environment_name}_${var.name}_${var.table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

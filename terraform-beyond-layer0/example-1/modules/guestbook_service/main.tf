#
# modules/guestbook_service/main.tf
#

resource "layer0_load_balancer" "guestbook" {
  name        = "${var.load_balancer_name}"
  environment = "${var.layer0_environment_id}"

  port {
    host_port      = 80
    container_port = 80
    protocol       = "http"
  }
}

resource "layer0_service" "guestbook" {
  name          = "${var.service_name}"
  environment   = "${var.layer0_environment_id}"
  deploy        = "${layer0_deploy.guestbook.id}"
  load_balancer = "${layer0_load_balancer.guestbook.id}"

  #scale = 3
}

resource "layer0_deploy" "guestbook" {
  name    = "${var.deploy_name}"
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

# note we are prefixing with the environment name also to ensure there won't be conflicts
# if multiple instance of this application were deployed
resource "aws_dynamodb_table" "guestbook" {
  name           = "${var.table_name}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

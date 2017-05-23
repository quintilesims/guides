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

resource "layer0_environment" "demo" {
  name = "demo"
}

resource "aws_dynamodb_table" "guestbook" {
  name           = "${var.table_name}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# configure the guestbook service to use the dynamo table 
module "guestbook" {
  source         = "github.com/quintilesims/layer0-examples//guestbook/module"
  environment_id = "${layer0_environment.demo.id}"
  backend_type   = "dynamo"
  backend_config = "${aws_dynamodb_table.guestbook.id}"
  access_key     = "${var.access_key}"
  secret_key     = "${var.secret_key}"
  region         = "${var.region}"
}

provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

resource "layer0_environment" "demo" {
  name = "demo"
}

module "guestbook" {
  source = "./modules/guestbook_service"

  name                    = "guestbook1"
  access_key              = "${var.access_key}"
  secret_key              = "${var.secret_key}"
  layer0_environment_id   = "${layer0_environment.demo.id}"
  layer0_environment_name = "${layer0_environment.demo.name}_guestbook"
}

# Sample remote backend configuration - to use uncomment and update bucket property 
# with a bucket name that already exists
/* terraform {
  backend "s3" {
    bucket = "demo-env-backend-bucket"
    key    = "demo-env/remote-backend/terraform.tfstate"
    region = "us-west-2"
  }
} */


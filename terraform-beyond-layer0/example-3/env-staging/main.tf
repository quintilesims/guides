module "guestbook" {
  source = "./../modules/guestbook_service"

  name          = "guestbook1"
  environment   = "${var.environment}"
  access_key    = "${var.access_key}"
  secret_key    = "${var.secret_key}"
  region        = "${var.region}"
  endpoint      = "${var.endpoint}"
  token         = "${var.token}"
  service_scale = "3"
}

# Sample remote backend configuration - to use uncomment and update bucket property 
# with a bucket name that already exists
/* terraform {
  backend "s3" {
    bucket = "dev-demo-env-backend-bucket"
    key    = "demo-env/remote-backend/dev/terraform.tfstate"
    region = "us-west-2"
  }
} */


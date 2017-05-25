provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

resource "layer0_environment" "demo" {
  name = "demo"
}

# configure the redis service
module "redis" {
  source = "github.com/quintilesims/redis//terraform"
  environment_id = "${layer0_environment.demo.id}"
}

# configure the guestbook service to use the redis backend 
module "guestbook" {
  source         = "github.com/quintilesims/layer0-examples//guestbook/module"
  environment_id = "${layer0_environment.demo.id}"
  scale          = 2
  backend_type   = "redis"
  backend_config = "${module.redis.load_balancer_url}:${var.redis_port}"
}

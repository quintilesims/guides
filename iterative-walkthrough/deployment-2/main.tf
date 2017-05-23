provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

resource "layer0_environment" "demo" {
  name = "demo"
}

# create a private load balancer named "redis"
resource "layer0_load_balancer" "redis" {
  name        = "redis"
  environment = "${layer0_environment.demo.id}"
  private     = true

  port {
    host_port      = "${var.redis_port}"
    container_port = "${var.redis_port}"
    protocol       = "tcp"
  }
}

# create a service named "redis"
resource "layer0_service" "redis" {
  name          = "redis"
  environment   = "${layer0_environment.demo.id}"
  deploy        = "${layer0_deploy.redis.id}"
  load_balancer = "${layer0_load_balancer.redis.id}"
  wait          = true
}

# create a deploy named "redis"
resource "layer0_deploy" "redis" {
  name    = "redis"
  content = "${data.template_file.redis.rendered}"
}

# template for the "redis" deploy
data "template_file" "redis" {
  template = "${file("Redis.Dockerrun.aws.json")}"

  vars {
    redis_port = "${var.redis_port}"
  }
}

# configure the guestbook service to use the redis backend 
module "guestbook" {
#  source         = "github.com/quintilesims/layer0-examples//guestbook/module"
source = "/home/ec2-user/go/src/github.com/quintilesims/layer0-examples/guestbook/module"
  environment_id = "${layer0_environment.demo.id}"
  scale = 2
  backend_type   = "redis"
  backend_config = "${layer0_load_balancer.redis.url}:${var.redis_port}"
}

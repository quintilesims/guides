provider "layer0" {
  endpoint        = "${var.endpoint}"
  token           = "${var.token}"
  skip_ssl_verify = true
}

resource "layer0_environment" "demo" {
  name = "demo"
}

module "consul" {
  source         = "github.com/quintilesims/consul//terraform"
  environment_id = "${layer0_environment.demo.id}"
}

resource "layer0_deploy" "redis" {
  name    = "redis"
  content = "${data.template_file.redis.rendered}"
}

data "template_file" "redis" {
  template = "${file("Redis.Dockerrun.aws.json")}"

  vars = {
    redis_port                   = "${var.redis_port}"
    redis_consul_service_name    = "${var.redis_consul_service_name}"
    consul_agent_container       = "${module.consul.agent_container}"
    consul_registrator_container = "${module.consul.registrator_container}"
    docker_volume                = "${module.consul.docker_volume}"
  }
}

module "redis" {
  source         = "github.com/quintilesims/redis//terraform"
  environment_id = "${layer0_environment.demo.id}"
  deploy_id      = "${layer0_deploy.redis.id}"
}

resource "layer0_deploy" "guestbook" {
  name    = "guestbook"
  content = "${data.template_file.guestbook.rendered}"
}

data "template_file" "guestbook" {
  template = "${file("Guestbook.Dockerrun.aws.json")}"

  vars {
    redis_consul_service_name     = "${var.redis_consul_service_name}"
    guestbook_consul_service_name = "${var.guestbook_consul_service_name}"
    consul_agent_container        = "${module.consul.agent_container}"
    consul_registrator_container  = "${module.consul.registrator_container}"
    docker_volume                 = "${module.consul.docker_volume}"
  }
}

module "guestbook" {
  source         = "github.com/quintilesims/guides//guestbook/module"
  environment_id = "${layer0_environment.demo.id}"
  deploy_id      = "${layer0_deploy.guestbook.id}"
}

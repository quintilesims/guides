variable "endpoint" {}

variable "token" {}

# Configure the Layer0 Provider
provider "layer0" {
	endpoint        = "${var.endpoint}"
	token           = "${var.token}"
	skip_ssl_verify = true
}

# Create an environment named "demo-env"
resource "layer0_environment" "demo-env" {
	name = "demo-env"
}

# Create a load balancer named "guestbook-lb" with port 80 exposed
resource "layer0_load_balancer" "guestbook-lb" {
	name        = "guestbook-lb"
	environment = "${layer0_environment.demo-env.id}"

	port {
		host_port      = 80
		container_port = 80
		protocol       = "http"
	}
}

# Create a service named "guestbook-svc"
resource "layer0_service" "guestbook-svc" {
	name          = "guestbook-svc"
	environment   = "${layer0_environment.demo-env.id}"
	deploy        = "${layer0_deploy.guestbook-dpl.id}"
	load_balancer = "${layer0_load_balancer.guestbook-lb.id}"
}

# Create a deploy named "guestbook-dpl"
resource "layer0_deploy" "guestbook-dpl" {
	name    = "guestbook-dpl"
	content = "${data.template_file.guestbook.rendered}"
}

# Template for the "guestbook" deploy
# See: https://www.terraform.io/docs/providers/template/d/file.html
data "template_file" "guestbook" {
	template = "${file("Guestbook.Dockerrun.aws.json")}"
    
    vars {
        redis_address = "${layer0_load_balancer.redis-lb.url}:6379"
    }
}

# Create a load balancer named "redis-lb" with port 6379 exposed
resource "layer0_load_balancer" "redis-lb" {
    name = "redis-lb"
    environment = "${layer0_environment.demo-env.id}"
	private= "true"

    port {
        host_port = 6379
        container_port = 6379
        protocol = "tcp"
    }
}

# Create a service named "redis-svc"
resource "layer0_service" "redis-svc" {
    name = "redis-svc"
    environment = "${layer0_environment.demo-env.id}"
    deploy = "${layer0_deploy.redis-dpl.id}"
    load_balancer = "${layer0_load_balancer.redis-lb.id}"
}

# Create a deploy named "redis-dpl"
resource "layer0_deploy" "redis-dpl" {
    name = "redis-dpl"
    content = "${data.template_file.redis.rendered}"
}

# Template for the "redis" deploy
data "template_file" "redis" {
    template = "${file("Redis.Dockerrun.aws.json")}"
}

# Show the load balancer's url as output
output "guestbook_url" {
  value = "${layer0_load_balancer.guestbook-lb.url}"
}
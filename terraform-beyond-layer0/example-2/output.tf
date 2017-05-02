output "environment_ids" {
  value = ["${layer0_environment.demo.*.id}"]
}

output "service_ids" {
  value = ["${layer0_service.guestbook.*.id}"]
}

output "guestbook_urls" {
  value = ["${layer0_load_balancer.guestbook.*.url}"]
}

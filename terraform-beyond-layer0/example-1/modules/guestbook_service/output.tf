#
# modules/guestbook_service/output.tf
# 

output "guestbook_url" {
  value = "${layer0_load_balancer.guestbook.url}"
}

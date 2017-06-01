output "guestbook_url" {
  value = "${module.guestbook.load_balancer_url}"
}

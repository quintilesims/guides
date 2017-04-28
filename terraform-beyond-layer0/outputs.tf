#
# outputs.tf
#

output "services" {
  value = "${module.guestbook.guestbook_url}"
}

#
# example-3/env-dev/output.tf
#

output "services" {
  value = "${module.guestbook.guestbook_url}"
}

#
# ./example2/output.tf
#

# Note the syntax for referencing resources using the count property
output "guestbook_urls" {
  value = "\n${join("\n", layer0_load_balancer.guestbook.*.url)}"
}

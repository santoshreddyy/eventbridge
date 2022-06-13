resource "aws_cloudwatch_event_archive" "this" {
  for_each = var.create && var.create_archives ? var.archives : {}
  name             = testarchieve
  event_source_arn = "arn:aws:events:us-east-1:301388746793:event-bus/default"
  description    = "test"
  event_pattern  = lookup(each.value, "event_pattern", null)
  retention_days = "1"
}

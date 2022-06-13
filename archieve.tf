resource "aws_cloudwatch_event_archive" "this" {
  for_each = var.create && var.create_archives ? var.archives : {}
  name             = each.key
  event_source_arn = try(each.value["event_source_arn"], aws_cloudwatch_event_bus.this[0].arn)
  description    = lookup(each.value, "description", null)
  event_pattern  = lookup(each.value, "event_pattern", null)
  retention_days = lookup(each.value, "retention_days", null)
}

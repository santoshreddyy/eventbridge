locals {
  eventbridge_rules = flatten([
    for index, rule in var.rules :
    merge(rule, {
      "name" = index
      "Name" = "${replace(index, "_", "-")}-rule"
    })
  ])
  eventbridge_targets = flatten([
    for index, rule in var.rules : [
      for target in var.targets[index] :
      merge(target, {
        "rule" = index
        "Name" = "${replace(index, "_", "-")}-rule"
      })
    ] if length(var.targets) != 0
  ])
  eventbridge_connections = flatten([
    for index, conn in var.connections :
    merge(conn, {
      "name" = index
      "Name" = "${replace(index, "_", "-")}-connection"
    })
  ])
  eventbridge_api_destinations = flatten([
    for index, dest in var.api_destinations :
    merge(dest, {
      "name" = index
      "Name" = "${replace(index, "_", "-")}-destination"
    })
  ])
}

resource "aws_cloudwatch_event_bus" "this" {
  count = var.create && var.create_bus ? 1 : 0

  name = var.bus_name
  tags = var.tags
}




   

    

  


resource "aws_cloudwatch_event_archive" "this" {
  for_each = var.create && var.create_archives ? var.archives : {}

  name             = each.key
  event_source_arn = try(each.value["event_source_arn"], aws_cloudwatch_event_bus.this[0].arn)

  description    = lookup(each.value, "description", null)
  event_pattern  = lookup(each.value, "event_pattern", null)
  retention_days = lookup(each.value, "retention_days", null)
}


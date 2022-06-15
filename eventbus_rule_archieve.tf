module "eventbridge" {
  source   = "terraform-aws-modules/eventbridge/aws"
  bus_name = "my-bus"
  tags = {
    Name = "my-bus"
  }
  create_targets = false

  rules = {
    logs = {
      description   = "Capture log data"
      event_pattern = jsonencode({ "source" : ["my.app.logs"] })
    }
  }
  create_archives = true
  archives = {
    "my-bus-launch-archive" = {
      description    = "EC2 AutoScaling Event archive",
      retention_days = 1
      event_pattern  = <<PATTERN
      {
        "source": ["aws.autoscaling"],
        "detail-type": ["EC2 Instance Launch Successful"]
      }
      PATTERN
    }
  }
}

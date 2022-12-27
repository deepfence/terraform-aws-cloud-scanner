# creates cloudwatch log group for log stream

resource "aws_cloudwatch_log_group" "log" {
  name_prefix       = "${var.name}-log-group"
  retention_in_days = var.cloudwatch_log_retention
  tags              = var.tags
  kms_key_id        = aws_kms_key.log_key.arn
}

# creates cloudwatch log stream from a particular source

resource "aws_cloudwatch_log_stream" "stream" {
  name           = "${var.name}-alerts"
  log_group_name = aws_cloudwatch_log_group.log.name
}

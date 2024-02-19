resource "aws_cloudwatch_log_group" "appstream_log_group" {
  name = "/Appstream/User/Logs"

  retention_in_days = 30
}
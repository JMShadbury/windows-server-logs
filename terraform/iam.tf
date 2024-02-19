resource "aws_iam_role" "appstream_cloudwatch_role" {
  name = "appstream_cloudwatch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "appstream.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy" "appstream_cloudwatch_policy" {
  name = "appstream_cloudwatch_policy"
  role = aws_iam_role.appstream_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect = "Allow",
        Resource = aws_cloudwatch_log_group.appstream_log_group.arn,
      },
    ],
  })
}
###############
#    IAM      #
###############
data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
    ]
    resources = [
      "arn:aws:xray:*:*:*"
    ]
  }
}

###############
#   Lambda    #
###############
data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/src/handler.py"
  output_path = "lambda.zip"
}
###############
#     IAM     #
###############
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowFromLambda",
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for logging from a lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "${var.function_name}-policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = data.aws_iam_policy_document.lambda.json
}

# Policy Attachment on the role.
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

###############
#   Lambda    #
###############
resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = "lambda.zip"
  description      = "Dumb lambda function utilizing x-ray tracing layer"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.8"
  handler          = "handler.lambda_handler"
  timeout          = 10
  layers           = [aws_lambda_layer_version.xray.arn]
  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]
  tracing_config {
    mode = "Active"
  }
}

###############
#   Layer     #
###############
resource "aws_lambda_layer_version" "xray" {
  filename            = "${path.module}/layer.zip"
  description         = "aws-xray-sdk module"
  layer_name          = "aws-xray-sdk"
  compatible_runtimes = ["python3.8"]
}

##########################
#   Cloudwatch Logs     #
##########################
# NOTE: The cloudwatch log group HAS to follow this naming convention for lambda logging
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

##########################
#   Cloudwatch Alarm     #
##########################
resource "aws_cloudwatch_metric_alarm" "lambda_alarm" {
  alarm_name          = "${var.function_name}-lambda-error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Lambda Errored Out"

  alarm_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  dimensions = {
    FunctionName = aws_lambda_function.lambda.function_name
  }
}

##########################
#       SNS Topic        #
##########################
resource "aws_sns_topic" "alarms" {
  name = "${var.function_name}-test-topic"
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = "jmeisele@yahoo.com"
}

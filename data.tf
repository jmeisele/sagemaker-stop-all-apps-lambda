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
      "sagemaker:ListApps",
      "sagemaker:DeleteApp"
    ]
    resources = [
      "arn:aws:sagemaker:*:*:*"
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
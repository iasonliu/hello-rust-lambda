data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.app_name}-${local.lambda_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "basic_execution_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "aws_iam_policy_document" "secretsmanager_access_policy_document" {
  statement {
    sid = "AllowGetRandomPassword"

    effect = "Allow"

    actions = [
      "secretsmanager:GetRandomPassword"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "secretsmanager_table_access_policy" {
  name        = "${local.app_name}-GetRandomPassword"
  description = "Allow GetRandomPassword Access Policy for app ${local.app_name}"
  policy      = data.aws_iam_policy_document.secretsmanager_access_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.secretsmanager_table_access_policy.arn
}
locals {
  region      = "ap-southeast-1"
  aws_profile = "aws-beach"
  app_name    = "myapp"
  lambda_name = "hello-rust-lambda"
  target_path = "../target/lambda/${local.lambda_name}/bootstrap.zip"
}



resource "aws_lambda_function" "lambda" {
  filename         = local.target_path
  function_name    = "${local.app_name}-${local.lambda_name}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "bootstrap"
  source_code_hash = filebase64sha256(local.target_path)
  runtime          = "provided.al2023"
  architectures    = ["arm64"]

  memory_size = 1024
}

resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}

output "lambda_url" {
  value = aws_lambda_function_url.lambda_url.function_url
}
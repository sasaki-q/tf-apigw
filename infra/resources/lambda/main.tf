resource "aws_lambda_function" "main" {
  filename      = var.file_path
  function_name = var.name
  handler       = var.handler
  role          = var.role_arn
  runtime       = var.runtime
}

resource "aws_api_gateway_resource" "main" {
  path_part   = var.path
  parent_id   = var.api_gw_root_id
  rest_api_id = var.api_gw_id
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = var.api_gw_id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = var.http_method
  authorization = var.authorization
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id             = var.api_gw_id
  resource_id             = aws_api_gateway_resource.main.id
  http_method             = var.http_method
  integration_http_method = var.default_integration.http_method
  type                    = var.default_integration.integration_type
  uri                     = var.lambda_invoke_arn
  credentials             = var.api_gw_assume_role_arn
}

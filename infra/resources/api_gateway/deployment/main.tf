resource "aws_api_gateway_deployment" "main" {
  rest_api_id = var.api_gw_id

  triggers = {
    redeployment = sha1(jsonencode(var.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = var.api_gw_id
  stage_name    = var.stage_name
}

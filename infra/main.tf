data "aws_caller_identity" "current" {}

################################################
# network
################################################

module "vpc" {
  source = "./resources/vpc"

  cidr = var.vpc_cidr
  name = var.vpc_name
}

module "public_subnet" {
  source = "./resources/subnet"

  for_each = { for idx, val in var.public_subnets : idx => val }

  vpc_id         = module.vpc.vpc_id
  cidr           = each.value.cidr
  name           = each.value.name
  az             = each.value.az
  route_table_id = module.vpc.public_route_table_id
}

module "private_subnet" {
  source = "./resources/subnet"

  for_each = { for idx, val in var.private_subnets : idx => val }

  vpc_id         = module.vpc.vpc_id
  cidr           = each.value.cidr
  name           = each.value.name
  az             = each.value.az
  route_table_id = module.vpc.private_route_table_id
}

################################################
# dynamodb
################################################
module "dynamodb" {
  source = "./resources/dynamodb"

  table_name = "messages"
  hash_key = {
    name = "user_id"
    type = "N"
  }
  range_key = {
    name = "created_at"
    type = "S"
  }
}

################################################
# api gateway
################################################

module "api_gateway" {
  source = "./resources/api_gateway"

  name = "my_api_gateway"
}

module "api_gateway_assume_role" {
  source = "./resources/iam/assume_role"

  assume_role_identifiers = ["apigateway.amazonaws.com"]
  role_name               = var.api_gw_assume_role_name
}

module "api_gateway_policy_attachment" {
  source = "./resources/iam/attachment"

  name         = "api_gateway_assume_role_attachment"
  iam_role_ids = [module.api_gateway_assume_role.id]
  policy_arn   = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

################################################
# lambda
################################################

module "lambda_assume_role" {
  source = "./resources/iam/assume_role"

  assume_role_identifiers = ["lambda.amazonaws.com"]
  role_name               = var.lambda_assume_role_name
}

module "lambda_policy" {
  source = "./resources/iam/policy"

  actions   = ["dynamodb:*"]
  name      = "lambda_dynamodb_policy"
  resources = ["arn:aws:dynamodb:ap-northeast-1:*:table/${module.dynamodb.table_name}"]
}

module "lambda_assume_role_attachment" {
  source = "./resources/iam/attachment"

  name         = "lambda_assume_role_attachment"
  iam_role_ids = [module.lambda_assume_role.id]
  policy_arn   = module.lambda_policy.arn
}

module "lambda" {
  source = "./resources/lambda"

  for_each = { for idx, val in var.lambda : idx => val }

  name      = each.value.name
  role_arn  = module.lambda_assume_role.arn
  handler   = each.value.handler
  file_path = each.value.file_path

  environment = each.value.use_dynamo ? {
    ENV           = var.env
    DYNAMO_REGION = "ap-northeast-1"
    DYNAMO_HOST   = "https://dynamodb.ap-northeast-1.amazonaws.com"
    } : {
    ENV = var.env
  }

  depends_on = [module.dynamodb]
}

################################################
# api gw * lambda
################################################

module "integration" {
  source = "./resources/api_gateway/integration"

  for_each = { for idx, val in var.api_gw_methods : idx => val }

  path                   = each.value.path
  api_gw_id              = module.api_gateway.id
  api_gw_root_id         = module.api_gateway.root_resource_id
  http_method            = each.value.http_method
  lambda_invoke_arn      = module.lambda[index(var.api_gw_methods, each.value)].invoke_arn
  api_gw_assume_role_arn = module.api_gateway_assume_role.arn

  depends_on = [module.lambda, module.api_gateway]
}

################################################
# api gateway deploymnet
################################################
module "deployment" {
  source = "./resources/api_gateway/deployment"

  api_gw_id  = module.api_gateway.id
  body       = module.api_gateway.body
  stage_name = var.env

  depends_on = [module.integration]
}

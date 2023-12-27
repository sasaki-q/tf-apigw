variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "myvpc"
}

variable "public_subnets" {
  type = list(object({
    az   = string
    name = string
    cidr = string
  }))

  default = [
    {
      az   = "ap-northeast-1a"
      name = "ap-northeast-1a-public"
      cidr = "10.0.1.0/24"
    },
    {
      az   = "ap-northeast-1c"
      name = "ap-northeast-1c-public"
      cidr = "10.0.2.0/24"
    },
    {
      az   = "ap-northeast-1d"
      name = "ap-northeast-1d-public"
      cidr = "10.0.3.0/24"
    },
  ]
}

variable "private_subnets" {
  type = list(object({
    az   = string
    name = string
    cidr = string
  }))

  default = [
    {
      az   = "ap-northeast-1a"
      name = "ap-northeast-1a-private"
      cidr = "10.0.4.0/24"
    },
    {
      az   = "ap-northeast-1c"
      name = "ap-northeast-1c-private"
      cidr = "10.0.5.0/24"
    },
    {
      az   = "ap-northeast-1d"
      name = "ap-northeast-1d-private"
      cidr = "10.0.6.0/24"
    }
  ]
}

variable "env" {
  type    = string
  default = "staging"
}

variable "api_gw_assume_role_name" {
  type    = string
  default = "api_gw_assume_role"
}

variable "lambda_assume_role_name" {
  type    = string
  default = "lambda_assume_role"
}

variable "lambda" {
  type = list(object({
    name       = string
    handler    = string
    file_path  = string
    use_dynamo = bool
  }))

  default = [
    {
      name       = "healthCheckHandler"
      handler    = "app/bin/hc"
      file_path  = "./resources/lambda/bin/hc.zip"
      use_dynamo = false
    },
    {
      name       = "listMessageHandler"
      handler    = "app/bin/message/list"
      file_path  = "./resources/lambda/bin/message/list.zip"
      use_dynamo = true
    },
    {
      name       = "createMessageHandler"
      handler    = "app/bin/message/create"
      file_path  = "./resources/lambda/bin/message/create.zip"
      use_dynamo = true
    }
  ]
}

variable "api_gw_methods" {
  type = list(object({
    path        = string
    http_method = string
  }))

  default = [
    {
      path        = "hc"
      http_method = "GET"
    },
    {
      path        = "message"
      http_method = "GET"
    },
    {
      path        = "message"
      http_method = "POST"
    }
  ]
}

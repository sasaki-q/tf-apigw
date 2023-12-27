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
    name      = string
    handler   = string
    file_path = string
  }))

  default = [
    {
      name      = "healthCheckHandler"
      handler   = "app/bin/hc"
      file_path = "./resources/lambda/bin/hc.zip"
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
    }
  ]
}

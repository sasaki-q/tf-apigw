variable "path" {
  type = string
}

variable "api_gw_root_id" {
  type = string
}

variable "api_gw_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "authorization" {
  type    = string
  default = "NONE"
}

variable "lambda_invoke_arn" {
  type = string
}

variable "api_gw_assume_role_arn" {
  type = string
}

variable "default_integration" {
  type = object({
    http_method      = string
    integration_type = string
  })

  default = {
    http_method      = "POST"
    integration_type = "AWS_PROXY"
  }
}

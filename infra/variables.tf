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

variable "subnets" {
  type = list(object({
    az        = string
    name      = string
    cidr      = string
    is_public = bool
  }))

  default = [
    {
      az        = "ap-northeast-1a"
      name      = "ap-northeast-1a-public"
      cidr      = "10.0.1.0/24"
      is_public = true
    },
    {
      az        = "ap-northeast-1c"
      name      = "ap-northeast-1c-public"
      cidr      = "10.0.2.0/24"
      is_public = true
    },
    {
      az        = "ap-northeast-1d"
      name      = "ap-northeast-1d-public"
      cidr      = "10.0.3.0/24"
      is_public = true
    },
    {
      az        = "ap-northeast-1a"
      name      = "ap-northeast-1a-private"
      cidr      = "10.0.4.0/24"
      is_public = false
    },
    {
      az        = "ap-northeast-1c"
      name      = "ap-northeast-1c-private"
      cidr      = "10.0.5.0/24"
      is_public = false
    },
    {
      az        = "ap-northeast-1d"
      name      = "ap-northeast-1d-private"
      cidr      = "10.0.6.0/24"
      is_public = false
    },
  ]
}

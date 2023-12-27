variable "name" {
  type = string
}

variable "handler" {
  type = string
}

variable "file_path" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "runtime" {
  type    = string
  default = "go1.x"
}

variable "name" {
  type = string
}

variable "endpoint_configuration_types" {
  type    = list(string)
  default = ["REGIONAL"]
}

variable "table_name" {
  type = string
}

variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "hash_key" {
  type = object({
    name = string
    type = string
  })
}

variable "range_key" {
  type = object({
    name = string
    type = string
  })
}

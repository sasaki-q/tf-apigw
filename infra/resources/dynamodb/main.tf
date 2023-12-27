resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key.name
  range_key    = var.range_key.name

  attribute {
    name = var.hash_key.name
    type = var.hash_key.type
  }

  attribute {
    name = var.range_key.name
    type = var.range_key.type
  }
}

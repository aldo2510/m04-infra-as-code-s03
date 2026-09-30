variable "table_name" {
  description = "DynamoDB table name."
  type        = string
}

variable "hash_key" {
  description = "DynamoDB partition key attribute name."
  type        = string
}

variable "tags" {
  description = "Tags applied to the table."
  type        = map(string)
}

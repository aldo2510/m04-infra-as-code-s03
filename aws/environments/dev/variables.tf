variable "aws_region" {
  description = "AWS region where the lab resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name."
  type        = string
}

variable "dynamodb_hash_key" {
  description = "DynamoDB partition key attribute name."
  type        = string
  default     = "id"
}

variable "log_group_name" {
  description = "CloudWatch Log Group name."
  type        = string
  default     = "/iac-lab/dev/application"
}

variable "log_retention_in_days" {
  description = "CloudWatch Logs retention period."
  type        = number
  default     = 14
}

variable "tags" {
  description = "Common tags required by the lab policies."
  type        = map(string)

  validation {
    condition = alltrue([
      contains(keys(var.tags), "Environment"),
      contains(keys(var.tags), "ManagedBy"),
      contains(keys(var.tags), "Owner"),
      contains(keys(var.tags), "CostCenter")
    ])
    error_message = "The tags map must contain Environment, ManagedBy, Owner and CostCenter."
  }
}

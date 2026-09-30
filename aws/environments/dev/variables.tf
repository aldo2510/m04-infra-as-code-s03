variable "student_id" {
  description = "Unique identifier for the student. Use lowercase letters, numbers and hyphens only."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.student_id))
    error_message = "student_id must contain only lowercase letters, numbers and hyphens, and be 3-20 characters long."
  }
}

variable "aws_region" {
  description = "AWS region where the lab resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "dynamodb_hash_key" {
  description = "DynamoDB partition key attribute name."
  type        = string
  default     = "id"
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

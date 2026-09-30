variable "name" {
  description = "CloudWatch Log Group name."
  type        = string
}

variable "retention_in_days" {
  description = "Retention period in days."
  type        = number

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545,
      731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, 0
    ], var.retention_in_days)
    error_message = "retention_in_days must be a value supported by CloudWatch Logs."
  }
}

variable "tags" {
  description = "Tags applied to the log group."
  type        = map(string)
}

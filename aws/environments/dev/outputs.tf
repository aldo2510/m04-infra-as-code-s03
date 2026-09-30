output "s3_bucket_name" {
  description = "S3 bucket name."
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.s3.bucket_arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name."
  value       = module.dynamodb.table_name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Log Group name."
  value       = module.cloudwatch_log_group.name
}

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.66"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.tags
  }
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = var.bucket_name
  tags        = var.tags
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name = var.table_name
  hash_key   = var.dynamodb_hash_key
  tags       = var.tags
}

module "cloudwatch_log_group" {
  source = "../../modules/cloudwatch-log-group"

  name              = var.log_group_name
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}

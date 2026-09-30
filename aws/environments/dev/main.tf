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

data "aws_caller_identity" "current" {}

locals {
  resource_prefix = "iac-s03-${var.student_id}-${data.aws_caller_identity.current.account_id}"
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = "${local.resource_prefix}-s3"
  tags        = var.tags
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name = "${local.resource_prefix}-ddb"
  hash_key   = var.dynamodb_hash_key
  tags       = var.tags
}

module "cloudwatch_log_group" {
  source = "../../modules/cloudwatch-log-group"

  name              = "/iac-s03/${var.student_id}/application"
  retention_in_days = var.log_retention_in_days
  tags              = var.tags
}

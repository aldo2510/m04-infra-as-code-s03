package main

required_tags := {
  "Environment",
  "ManagedBy",
  "Owner",
  "CostCenter",
}

taggable_resources := {
  "aws_s3_bucket",
  "aws_dynamodb_table",
  "aws_cloudwatch_log_group",
}

deny contains msg if {
  resource := input.resource_changes[_]
  taggable_resources[resource.type]
  resource.change.actions[_] == "create"

  tags := object.get(resource.change.after, "tags", {})
  tag_keys := {key | key := object.keys(tags)[_]}
  missing := required_tags - tag_keys

  count(missing) > 0
  msg := sprintf("%s is missing required tags: %v", [
    resource.address,
    sort([tag | tag := missing[_]]),
  ])
}

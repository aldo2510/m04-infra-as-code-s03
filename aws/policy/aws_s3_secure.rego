package main

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_versioning"
  resource.change.actions[_] == "create"

  configuration := object.get(resource.change.after, "versioning_configuration", [])
  count(configuration) == 0
  msg := sprintf("%s must configure S3 versioning", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_versioning"
  resource.change.actions[_] == "create"

  configuration := object.get(resource.change.after, "versioning_configuration", [])
  count(configuration) > 0
  configuration[0].status != "Enabled"
  msg := sprintf("%s must enable S3 versioning", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_server_side_encryption_configuration"
  resource.change.actions[_] == "create"

  rules := object.get(resource.change.after, "rule", [])
  count(rules) == 0
  msg := sprintf("%s must configure S3 server-side encryption", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_server_side_encryption_configuration"
  resource.change.actions[_] == "create"

  rules := object.get(resource.change.after, "rule", [])
  count(rules) > 0
  encryption := object.get(rules[0], "apply_server_side_encryption_by_default", [])
  count(encryption) == 0
  msg := sprintf("%s must configure a default S3 encryption algorithm", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_server_side_encryption_configuration"
  resource.change.actions[_] == "create"

  rules := object.get(resource.change.after, "rule", [])
  count(rules) > 0
  encryption := object.get(rules[0], "apply_server_side_encryption_by_default", [])
  count(encryption) > 0
  encryption[0].sse_algorithm != "AES256"
  msg := sprintf("%s must use AES256 server-side encryption", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.change.actions[_] == "create"

  after := resource.change.after
  after.block_public_acls != true
  msg := sprintf("%s must block public ACLs", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.change.actions[_] == "create"

  after := resource.change.after
  after.block_public_policy != true
  msg := sprintf("%s must block public bucket policies", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.change.actions[_] == "create"

  after := resource.change.after
  after.ignore_public_acls != true
  msg := sprintf("%s must ignore public ACLs", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket_public_access_block"
  resource.change.actions[_] == "create"

  after := resource.change.after
  after.restrict_public_buckets != true
  msg := sprintf("%s must restrict public buckets", [resource.address])
}

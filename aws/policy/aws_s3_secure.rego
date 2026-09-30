package main

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  resource.change.actions[_] == "create"

  versioning := object.get(resource.change.after, "versioning", [])
  count(versioning) == 0
  msg := sprintf("%s must enable S3 versioning", [resource.address])
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.type == "aws_s3_bucket"
  resource.change.actions[_] == "create"

  encryption := object.get(resource.change.after, "server_side_encryption_configuration", [])
  count(encryption) == 0
  msg := sprintf("%s must configure server-side encryption", [resource.address])
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
  after.restrict_public_buckets != true
  msg := sprintf("%s must restrict public buckets", [resource.address])
}

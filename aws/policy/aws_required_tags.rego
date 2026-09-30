package main

required_tags := {
  "Environment",
  "ManagedBy",
  "Owner",
  "CostCenter",
}

resource_type_tags(resource) = tags if {
  tags := object.get(resource.change.after, "tags", {})
}

deny contains msg if {
  resource := input.resource_changes[_]
  resource.change.actions[_] == "create"
  tags := resource_type_tags(resource)
  tag_keys := {key | key := object.keys(tags)[_]}
  missing := required_tags - tag_keys
  count(missing) > 0
  msg := sprintf("%s is missing required tags: %v", [resource.address, sort([tag | tag := missing[_]])])
}

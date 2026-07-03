# Module: naming-standard

This module standardizes names and tags for learning projects.

It creates no cloud resources. It only returns calculated outputs.

## Inputs

- `project_name`
- `environment`
- `owner_name`
- `component_names`
- `extra_tags`

## Outputs

- `name_prefix`
- `resource_names`
- `common_tags`
- `summary`

## Why This Module Exists

Small modules like this are useful for learning module mechanics. In production, you may keep naming and tagging as locals unless the pattern is shared across many repositories.

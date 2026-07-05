# Next: AI Through Terraform Capstone

This is the recommended next project after the 7-day foundation.

## Goal

Build a small AI-ready AWS platform using Terraform.

## Proposed Architecture

```text
User
  -> API Gateway
  -> Lambda or ECS service
  -> Amazon Bedrock or model provider integration
  -> DynamoDB request table
  -> S3 prompt/input/output bucket
  -> CloudWatch logs and alarms
```

## Terraform Topics Reused

- Providers and version constraints.
- Variables and tfvars for environments.
- Modules for API, compute, storage, and IAM.
- Remote state with S3 backend and lockfile.
- Least privilege IAM.
- Outputs for deployed endpoints.
- Security review checklist from Day 7.

## Suggested Build Order

1. Remote backend bootstrap.
2. Network or serverless baseline.
3. S3 and DynamoDB storage.
4. IAM roles and policies.
5. Lambda or ECS compute.
6. API Gateway.
7. Bedrock integration.
8. Observability.
9. Dev/prod environment values.
10. Final README and architecture diagram.

## Completion Criteria

The capstone is complete when a student can:

- Deploy the platform from Terraform.
- Explain each module.
- Show a safe plan before apply.
- Demonstrate least privilege IAM.
- Destroy non-production resources cleanly.

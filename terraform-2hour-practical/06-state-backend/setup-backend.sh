#!/bin/bash
set -euo pipefail

REGION="us-east-1"
USER_SLUG="$(whoami | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')"
USER_SLUG="${USER_SLUG:-student}"
BUCKET_NAME="terraform-state-demo-${USER_SLUG}-$(date +%s)"

echo "======================================"
echo "  Setting up Terraform Remote Backend"
echo "======================================"
echo "Bucket: $BUCKET_NAME"
echo "Region: $REGION"
echo "Locking: S3 lock file via use_lockfile=true"
echo ""

echo "[1/4] Creating S3 bucket..."
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION"

echo "[2/4] Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

echo "[3/4] Blocking all public access to state bucket..."
aws s3api put-public-access-block \
  --bucket "$BUCKET_NAME" \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "[4/4] Enabling default server-side encryption..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

echo "$BUCKET_NAME" > .bucket-name

echo ""
echo "======================================"
echo "  Backend setup complete"
echo "======================================"
echo "Update backend.tf with:"
echo "  bucket = \"$BUCKET_NAME\""
echo "Then run:"
echo "  terraform init"
echo "Bucket name saved to .bucket-name"
echo "======================================"

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Run setup-backend.sh first, then replace this placeholder with the bucket name it prints.
    bucket = "terraform-state-demo-YOUR-BUCKET-NAME"

    key                  = "terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "env"

    encrypt      = true
    use_lockfile = true
  }
}

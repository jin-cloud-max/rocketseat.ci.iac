terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
  }

  backend "s3" {
    bucket = "rocketseat-iac-terraform-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"

    # profile = "jin"
  }

}

provider "aws" {
  region = "us-east-1"

  # profile = var.AWS_PROFILE
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "rocketseat-iac-terraform-state"

  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    IaC       = "True"
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform-state" {
  bucket = aws_s3_bucket.terraform-state.bucket

  versioning_configuration {
    status = "Enabled"
  }
}
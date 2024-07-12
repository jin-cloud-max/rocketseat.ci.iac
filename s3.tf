resource "aws_s3_bucket" "bucket-by-ci-cd-pipeline" {
  bucket = "rocketseat-iac-bucket-by-ci-cd-pipeline"

  force_destroy = true

  tags = {
    IaC       = "True"
    CreatedBy = "Terraform"
  }
}
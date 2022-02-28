resource "aws_s3_bucket" "unhackble-product-analysis" {
  bucket = "unhackble-product-analysis-bucket"
  acl    = "public-read-write"

  tags = {
    Name        = "product"
    Environment = "internal"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "<Provide the ARN of the KMS key>"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
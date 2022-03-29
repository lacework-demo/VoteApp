resource "aws_s3_bucket" "unhackble-product-analysis" {
  bucket = "unhackble-product-analysis-bucket"
  acl    = "public-read-write"

  tags = {
    Name        = "product"
    Environment = "internal"
  }
  block_public_acls = true
}
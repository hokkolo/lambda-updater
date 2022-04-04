variable "bucket_name" {}

output "bucket-id" {
  value = aws_s3_bucket.lambda_bucket.id
}



# Output: Name of the provisioned S3 bucket for KYC uploads, useful for referencing in other modules or outputs.
output "bucket_name" {
  description = "Name of the KYC uploads S3 bucket"
  value       = aws_s3_bucket.kyc_uploads.bucket
}

# Output: ARN (Amazon Resource Name) of the KYC S3 bucket, often needed for permissions and integrations.
output "bucket_arn" {
  description = "ARN of the KYC uploads S3 bucket"
  value       = aws_s3_bucket.kyc_uploads.arn
}

# The main resource that provisions the S3 bucket for secure KYC document uploads.
resource "aws_s3_bucket" "kyc_uploads" {
  bucket = var.kyc_upload_bucket_name
  acl    = "private"   # Ensures uploaded documents are not publicly accessible by default.

  # You can add additional S3 bucket configuration here if needed (e.g., versioning, encryption, lifecycle).
}

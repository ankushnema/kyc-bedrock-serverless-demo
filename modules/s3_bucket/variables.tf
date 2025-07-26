# Input variable for the S3 bucket's name, ensuring each deployment/environment has a unique and traceable bucket.
variable "kyc_upload_bucket_name" {
  description = "Name of the S3 bucket for KYC document uploads."
  type        = string
}

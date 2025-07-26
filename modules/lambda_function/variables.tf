# Input variables for Lambda function module, for real KYC doc processing.

variable "kyc_doc_lambda_name" {
  description = "Name of the Lambda function for KYC document processing."
  type        = string
}

variable "kyc_upload_bucket_arn" {
  description = "ARN of the S3 bucket for uploads."
  type        = string
}

variable "kyc_docs_table_arn" {
  description = "ARN of the DynamoDB table for processed docs."
  type        = string
}

variable "kyc_upload_bucket_name" {
  description = "Name of the S3 upload bucket (passed as environment variable)."
  type        = string
}

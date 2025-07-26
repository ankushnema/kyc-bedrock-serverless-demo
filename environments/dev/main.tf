# Terraform provider configuration for AWS (set your region)
provider "aws" {
  region = "us-east-1"
}

# S3 bucket for KYC document uploads
module "kyc_upload_bucket" {
  source = "../../modules/s3_bucket"

  kyc_upload_bucket_name = "kyc-uploads-${terraform.workspace}"
}

# DynamoDB table for KYC metadata and summaries
module "kyc_docs_table" {
  source = "../../modules/dynamodb_table"

  kyc_docs_table_name = "kyc-docs-metadata-${terraform.workspace}"
}

# Lambda function for processing uploads and invoking Bedrock
module "kyc_doc_lambda" {
  source = "../../modules/lambda_function"

  kyc_doc_lambda_name    = "kyc-doc-processor-${terraform.workspace}"
  kyc_upload_bucket_arn  = module.kyc_upload_bucket.bucket_arn
  kyc_upload_bucket_name = module.kyc_upload_bucket.bucket_name
  kyc_docs_table_arn     = module.kyc_docs_table.table_arn
}

# (You will later add S3->Lambda event notification, outputs, etc.)
# S3 Event Notification triggers Lambda on new uploads.
resource "aws_s3_bucket_notification" "kyc_upload_trigger" {
  bucket = module.kyc_upload_bucket.bucket_name

  lambda_function {
    lambda_function_arn = module.kyc_doc_lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    module.kyc_doc_lambda,
    module.kyc_upload_bucket
  ]
}

# Allow S3 to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = module.kyc_doc_lambda.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.kyc_upload_bucket.bucket_arn
}

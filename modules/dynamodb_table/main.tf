# DynamoDB table for storing metadata and extracted AI insights from KYC document uploads.
resource "aws_dynamodb_table" "kyc_docs" {
  name         = var.kyc_docs_table_name
  billing_mode = "PAY_PER_REQUEST"  # Uses on-demand capacity to stay in the AWS Free Tier and auto-scale.

  # Primary key: Document ID (string, e.g., UUID or S3 object key).
  hash_key     = "document_id"

  attribute {
    name = "document_id"
    type = "S"
  }

  # Add more attributes if you want to enable sort keys or secondary indexes.
  # Example: Range key for timestamp, or GSI for user_id.
}

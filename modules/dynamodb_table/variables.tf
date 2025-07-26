# Input variable for specifying the DynamoDB table name for KYC document storage.
variable "kyc_docs_table_name" {
  description = "DynamoDB table name for storing KYC document records and AI-extracted fields."
  type        = string
}

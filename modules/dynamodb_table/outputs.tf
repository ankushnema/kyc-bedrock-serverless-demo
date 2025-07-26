# Output: DynamoDB table name (useful for Lambda integration or admin dashboards).
output "table_name" {
  description = "Name of the DynamoDB table for KYC documents"
  value       = aws_dynamodb_table.kyc_docs.name
}

# Output: ARN of the table, needed for IAM roles and Lambda permissions.
output "table_arn" {
  description = "ARN of the DynamoDB table for KYC documents"
  value       = aws_dynamodb_table.kyc_docs.arn
}

# Output: Lambda function name, for downstream modules or monitoring.
output "lambda_function_name" {
  description = "Name of the KYC document processing Lambda function"
  value       = aws_lambda_function.kyc_doc_processor.function_name
}

# Output: Lambda ARN (for event source mapping, etc.)
output "lambda_function_arn" {
  description = "ARN of the KYC document processing Lambda function"
  value       = aws_lambda_function.kyc_doc_processor.arn
}

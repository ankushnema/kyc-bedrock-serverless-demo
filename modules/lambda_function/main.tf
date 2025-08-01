# Lambda function resource—actual code package to be provided later.
resource "aws_lambda_function" "kyc_doc_processor" {
  function_name = var.kyc_doc_lambda_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"  # Adjust as per your actual handler (Python example)
  runtime       = "python3.12"                     # Or nodejs18.x, etc.
  filename      = "${path.root}/lambda_package.zip"  # Path to deployment package (to be built)
  timeout       = 60
  memory_size   = 256

  # Pass S3 bucket/table names as environment variables for code flexibility
  environment {
    variables = {
      UPLOAD_BUCKET   = var.kyc_upload_bucket_name
      DYNAMO_TABLE_ARN = var.kyc_docs_table_arn
    }
  }
}

# Lambda execution role with minimum permissions for S3 (read), DynamoDB (write), and Bedrock (summarize).
resource "aws_iam_role" "lambda_exec" {
  name = "${var.kyc_doc_lambda_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for S3 read, DynamoDB write, and Bedrock InvokeModel permissions
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.kyc_doc_lambda_name}-policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 Read Access
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${var.kyc_upload_bucket_arn}/*"
      },
      # DynamoDB Write Access
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = var.kyc_docs_table_arn
      },
      # Bedrock InvokeModel permission
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      },
      # Basic Lambda execution
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

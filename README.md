# KYC Document Automation: AI-Powered Serverless Pipeline

This project is a launchpad for production-ready automation of document-based workflows—such as KYC (Know Your Customer) document processing, support ticket summarization, log analytics, and other custom AI-powered data flows. It demonstrates how to combine AWS serverless services with foundation models on Amazon Bedrock for advanced content extraction, summarization, and classification.

## Project Vision

Build a scalable, observable, and cost-efficient serverless workflow that ingests uploaded documents (text, images, PDFs), invokes generative AI (Bedrock) for summarization/classification, and stores both raw and enriched metadata for analytics, compliance, or downstream automation.

## Objectives

- **Hands-on IaC:** Provision all infrastructure with reusable Terraform modules (S3, Lambda, DynamoDB, IAM, etc.), supporting automation, auditability, and repeatability.
- **Observability:** Implement CloudWatch logging, structured logs, and the foundation for custom metrics/alarms.
- **AI/ML Enrichment:** Use Amazon Bedrock LLMs to analyze, summarize, and classify KYC docs, tickets, or logs.
- **Extensibility:** Modular codebase designed for multi-region expansion (S3 cross-region replication, DynamoDB Global Tables).
- **CI/CD Readiness:** Ready for automated deployments via GitHub Actions, with policy for review, test, and safe promotion.
- **Cost-Efficiency:** Operate in the AWS Free Tier or with strict usage controls for Bedrock (test/demo volume only).
- **Production Blueprint:** Acts as a robust starting point for real-world document automation—KYC onboarding, compliance review, support intelligence, or log enrichment.

## Use Case Example

1. A customer uploads a scanned KYC document (PDF or image) or support ticket to an S3 bucket.
2. The upload triggers a Lambda function.
3. Lambda:
    - Reads the file.
    - Uses Amazon Bedrock for LLM-powered summarization/classification (e.g., “Extract name/address/date of birth from KYC”, or “Summarize this ticket’s main concern”).
    - Writes both extracted/summary fields and raw metadata to DynamoDB.
    - (Optional) Notifies compliance/ops teams if a document fails checks or needs review.
4. All activity is logged and observable in CloudWatch.

## Architecture

S3 (upload doc/ticket/image)
|
[Event]
|
Lambda (read, call Bedrock, parse/extract, write to DynamoDB)
|
DynamoDB (store raw + enriched results)
|
(Optional) SNS/EventBridge (alert/trigger workflow)


## AI/ML Integration

- **Text/Document Summarization:** Use Bedrock LLMs for high-quality, customizable summaries or key field extraction from uploaded documents.
- **Classification:** Auto-tag or classify support tickets, detect risk flags, or triage urgent requests.
- **Scanned Images:** (Optional extension) Integrate Textract for OCR before Bedrock summarization.

**Bedrock is pay-as-you-go. Use test/demo volume only and monitor billing for full cost control.**

---

## Getting Started

Step-by-step instructions for provisioning modules, integrating Bedrock, and running safe test uploads will follow in this repo.
## Step-by-Step Setup

### 1. **Repository Structure**
kyc-bedrock-serverless-demo/
├── README.md
├── lambda_src/
│ └── lambda_function.py # Lambda function code (Python)
├── lambda_package.zip # Deployment package for Lambda
├── modules/
│ ├── s3_bucket/ # S3 module (Terraform)
│ ├── dynamodb_table/ # DynamoDB module (Terraform)
│ └── lambda_function/ # Lambda+IAM module (Terraform)
└── environments/
└── dev/
└── main.tf # Instantiates and wires modules together


---

### 2. **S3 Module**
- Provisions an S3 bucket to receive KYC document uploads.
- The bucket is private and uniquely named per environment.
- Outputs: bucket name and ARN, for use by Lambda and permissions.

### 3. **DynamoDB Table Module**
- Provisions a DynamoDB table for metadata and Bedrock AI summaries.
- Uses on-demand billing for cost efficiency.
- Outputs: table name and ARN, used by Lambda for writes.

### 4. **Lambda Module**
- Deploys a Python Lambda function (code in `lambda_src/lambda_function.py`).
- Lambda is triggered by S3 uploads and reads files from the bucket.
- Calls Amazon Bedrock (Claude 3 model) to summarize/extract KYC info.
- Writes the summary and metadata to DynamoDB.
- IAM role grants read from S3, write to DynamoDB, and Bedrock access.

### 5. **Environment Wiring (environments/dev/main.tf)**
- Instantiates all modules with explicit names and references.
- Adds S3 bucket notification to automatically trigger Lambda on upload.
- Adds Lambda permission so S3 can invoke the function.

### 6. **Lambda Function Code**
- Reads new document from S3 event.
- Sends text to Bedrock for summarization or field extraction.
- Writes results (document ID, summary, raw content) to DynamoDB.
- All environment variables (bucket, table) are provided via Terraform for flexibility.

### 7. **Deploying the Stack**
- From project root, initialize Terraform and deploy:
    ```sh
    cd environments/dev
    terraform init
    terraform plan
    terraform apply
    ```
- **NOTE:** Make sure your AWS credentials are configured for your user/account.

### 8. **How it Works in Production**
- Users (or other systems) upload documents to the KYC S3 bucket.
- Each upload triggers the Lambda function.
- Lambda reads the document, summarizes or classifies it with Bedrock, and stores the result in DynamoDB.
- (Optional) You can add notification or workflow triggers for compliance or review automation.

---

## Customization and Extensibility

- Change the Lambda code to use different Bedrock prompts for summarization, extraction, or classification.
- Extend the DynamoDB table for more complex metadata, GSI indexes, or versioning.
- Add CI/CD (e.g., GitHub Actions) for Terraform deployment and Lambda packaging.
- Add CloudWatch alarms or dashboards for monitoring activity.

---

## Cost & Safety Notes

- S3, DynamoDB, and Lambda use AWS Free Tier by default.
- Amazon Bedrock is pay-as-you-go—limit use to demo/test volume to avoid charges.
- Monitor usage and billing in your AWS account.

---

## Want to Add More?

- Use Textract for OCR before Bedrock summarization if handling images.
- Add S3 versioning or encryption for compliance.
- Wire SNS/EventBridge for automated escalations (e.g., if a document fails checks).

---

## Contact & Credits

Built for real-world SRE/Cloud Engineering practices.  
You can reach the maintainer at ankushnema111@gmail.com.

---

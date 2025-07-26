import boto3
import json
import os

def lambda_handler(event, context):
    """
    Lambda handler to process KYC document uploads from S3,
    call Amazon Bedrock for summarization/classification,
    and store results in DynamoDB.
    """
    s3 = boto3.client("s3")
    bedrock = boto3.client("bedrock-runtime")
    dynamodb = boto3.client("dynamodb")

    # Get environment variables
    bucket_name = os.environ["UPLOAD_BUCKET"]
    table_arn   = os.environ["DYNAMO_TABLE_ARN"]

    for record in event["Records"]:
        key = record["s3"]["object"]["key"]

        # Download file from S3
        obj = s3.get_object(Bucket=bucket_name, Key=key)
        content = obj["Body"].read().decode("utf-8")

        # Prepare prompt for Bedrock (summarize KYC doc)
        prompt = f"Summarize the following KYC document:\n\n{content}\n\nSummary:"
        response = bedrock.invoke_model(
            modelId="anthropic.claude-3-sonnet-20240229-v1:0",
            body=json.dumps({
                "prompt": prompt,
                "max_tokens_to_sample": 256
            })
        )
        bedrock_response = json.loads(response["body"].read())
        summary = bedrock_response.get("completion", "")

        # Store result in DynamoDB
        dynamodb.put_item(
            TableName=table_arn.split("/")[-1],
            Item={
                "document_id": {"S": key},
                "summary": {"S": summary},
                "raw_content": {"S": content}
            }
        )

    return {"status": "ok"}

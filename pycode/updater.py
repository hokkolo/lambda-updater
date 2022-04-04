import boto3
import json

client = boto3.client("s3")
lambda_client = boto3.client("lambda")

def lambda_handler(event, context):

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    file = event["Records"][0]["s3"]["object"]["key"]


    get_version = client.get_object(
             Bucket = bucket,
             Key = file
             )

    versionId = (get_version["VersionId"]) #Getting the latest version of the code 

    update_lambda = lambda_client.update_function_code(
                     FunctionName= file.split("/")[-1].split(".")[0],
                     S3Bucket=bucket,
                     S3Key=file,
                     S3ObjectVersion= versionId
                     )

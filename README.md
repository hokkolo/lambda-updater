# Lambda-updater
Ever been in a situation where you want your Lambda function code to be updated automatically from S3 bucket without any manual intervention or re-provisioning?
Here is a solution

## Explanation
Detailed explanation of the project is available on my [medium profile](https://medium.com/p/7b7eb12a43cf)

## How to
- Clone the repo
- terraform init
- terraform plan
- terraform apply

## Testing
Based on the names given to the function. Create zip files with names "demo-fun1.zip" and "demo-fun2.zip". Upload to corresponding buckets. Corresponding Lambda function codes will be updated.

variable "lambda-role-name" {}
variable "lambda-logging-name" {}
variable "lambda-s3-access" {}

output "lambda-role" {
  value = aws_iam_role.lambda_role.arn
}

output "policy-attach" {
  value = aws_iam_role_policy_attachment.policy_attach
}

output "policy-loggin-arn" {
  value = aws_iam_policy.lambda_logging.arn
}

output "policy-s3access-arn" {
  value = aws_iam_policy.s3_access-lambda.arn
}
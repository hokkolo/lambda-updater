output "updater-arn" {
  value = aws_lambda_function.updater-lambda.arn
}

output "updater-function-name" {
  value = aws_lambda_function.updater-lambda.function_name
}
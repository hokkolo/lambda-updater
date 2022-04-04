
resource "aws_lambda_function" "updater-lambda" {
  function_name                  = "demo-updater"
  filename                       = "${path.root}/pycodezip/code.zip"
  role                           =  aws_iam_role.updater-role.arn
  handler                        = "updater.lambda_handler"
  runtime                        = "python3.8"
  depends_on = [module.iam_for_lambda.policy-attach,
  aws_iam_role_policy_attachment.updater-lambda-1,
  aws_iam_role_policy_attachment.updater-lambda-3]
}
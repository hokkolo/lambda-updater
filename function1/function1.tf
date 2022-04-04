module "create_s3_fun1" {
  source                   = "../s3bucket"
  bucket_name              = "function1-buck-9110"
}

module "iam_for_lambda" {
  source                   = "../lambda-iam"
  lambda-role-name         = "fun1-role"
  lambda-logging-name      = "fun1-lambda-logging"
  lambda-s3-access         = "fun1-s3-access"
}

resource "aws_s3_object" "s3-object-fun1" {
  bucket                   = module.create_s3_fun1.bucket-id
  key                      = "code.zip"
  source                   = "${path.root}/pycodezip/code.zip"
}

resource "aws_lambda_function" "fun1-lambda" {
  function_name            = "demo-fun1"
  s3_bucket                = module.create_s3_fun1.bucket-id
  s3_key                   = aws_s3_object.s3-object-fun1.key
  role                     = module.iam_for_lambda.lambda-role
  handler                  = "testcode1.lambda_handler"
  runtime                        = "python3.8"
  depends_on               = [module.iam_for_lambda.policy-attach]
}


resource "aws_s3_bucket_notification" "fun1-notification" {
  bucket                   = module.create_s3_fun1.bucket-id
  lambda_function {
    lambda_function_arn = var.updater-function-arn
    events = ["s3:ObjectCreated:*"]
  }
  depends_on = [
    aws_lambda_permission.fun1-permission
  ]
}

resource "aws_lambda_permission" "fun1-permission" {
  statement_id             = "AllowS3Invokefun1"
  action                   = "lambda:InvokeFunction"
  function_name            = var.updater-function-name
  principal                = "s3.amazonaws.com"
  source_arn               = "arn:aws:s3:::${module.create_s3_fun1.bucket-id}"
}
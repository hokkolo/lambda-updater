module "create_s3_fun2" {
  source                   = "../s3bucket"
  bucket_name              = "function2-buck-9110"
}

module "iam_for_lambda" {
  source                   = "../lambda-iam"
  lambda-role-name         = "fun2-role"
  lambda-logging-name      = "fun2-lambda-logging"
  lambda-s3-access         = "fun2-s3-access"
}

resource "aws_s3_object" "s3-object-fun2" {
  bucket                   = module.create_s3_fun2.bucket-id
  key                      = "code.zip"
  source                   = "${path.root}/pycodezip/code.zip"
}

resource "aws_lambda_function" "fun2-lambda" {
  function_name            = "demo-fun2"
  s3_bucket                = module.create_s3_fun2.bucket-id
  s3_key                   = aws_s3_object.s3-object-fun2.key
  role                     = module.iam_for_lambda.lambda-role
  handler                  = "testcode2.lambda_handler"
  runtime                  = "python3.8"
  depends_on               = [module.iam_for_lambda.policy-attach]
}


resource "aws_s3_bucket_notification" "fun2-notification" {
  bucket                   = module.create_s3_fun2.bucket-id
  lambda_function {
    lambda_function_arn = var.updater-function-arn
    events = ["s3:ObjectCreated:*"]
  }
  depends_on = [
    aws_lambda_permission.fun2-permission
  ]
}

resource "aws_lambda_permission" "fun2-permission" {
  statement_id             = "AllowS3Invokefun2"
  action                   = "lambda:InvokeFunction"
  function_name            = var.updater-function-name
  principal                = "s3.amazonaws.com"
  source_arn               = "arn:aws:s3:::${module.create_s3_fun2.bucket-id}"
}
module "iam_for_lambda" {
  source                         = "../lambda-iam"
  lambda-role-name               = "updater-role"
  lambda-logging-name            = "updater-lambda-logging"
  lambda-s3-access               = "updater-s3-access"
}

resource "aws_iam_policy" "lambda_access" {
  name = "iam_policy_lambda_access-updater"
  path = "/"
  description = "lambda access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
                "cloudformation:DescribeStacks",
                "cloudformation:ListStackResources",
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricData",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "kms:ListAliases",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "lambda:*",
                "logs:DescribeLogGroups",
                "states:DescribeStateMachine",
                "states:ListStateMachines",
                "tag:GetResources",
                "xray:GetTraceSummaries",
                "xray:BatchGetTraces"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "lambda.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        }
    ]
}
EOF
}

# resource "aws_iam_policy" "s3_access" {
#   name = "iam_policy_s3_access-updater"
#   path = "/"
#   description = "s3 access"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#         "Action": [
#         "s3:*",
#         "s3-object-lambda:*"
#        ],
#        "Resource": "*"
#     }
#    ]
# }
# EOF
# }

resource "aws_iam_policy" "lambda-invoker" {
  name = "lambda-invoker"
  path = "/"
  description = "iam for lambda invoker"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "updater-role" {
  name = "updater-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "updater-lambda-1" {
  role = aws_iam_role.updater-role.name
  policy_arn = aws_iam_policy.lambda-invoker.arn
}

resource "aws_iam_role_policy_attachment" "updater-lambda-2" {
  role = aws_iam_role.updater-role.name
  policy_arn = module.iam_for_lambda.policy-loggin-arn
}

resource "aws_iam_role_policy_attachment" "updater-lambda-3" {
  role = aws_iam_role.updater-role.name
  policy_arn = aws_iam_policy.lambda_access.arn
}

resource "aws_iam_role_policy_attachment" "updater-lambda-4" {
  role = aws_iam_role.updater-role.name
  policy_arn = module.iam_for_lambda.policy-s3access-arn
}



resource "aws_iam_user" "ryanmissett_blog_github_deploy" {
  name = "ryanmissett_blog_github_deploy"
}

data "aws_iam_policy_document" "ryanmissett_blog_github_deploy_policy" {
  # backend management

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::ryanmissett-terraform-backend/blog",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::ryanmissett-terraform-backend",
    ]
  }

  # blog resource management

  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::ryanmissett-blog-frontend",
      "arn:aws:s3:::ryanmissett-blog-frontend/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "cloudfront:*",
    ]
    resources = [
      "arn:aws:cloudfront::635451031443:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:GetRole",
    ]
    resources = [
      aws_iam_role.ryanmissett_blog_lambda_hello_world.arn,
    ]
  }
}

resource "aws_iam_user_policy" "ryanmissett_blog_github_deploy_policy" {
  name = "ryanmissett_blog_github_deploy_policy"
  user = aws_iam_user.ryanmissett_blog_github_deploy.name
  policy = data.aws_iam_policy_document.ryanmissett_blog_github_deploy_policy.json
}

# lambda deploy functionality

data "aws_iam_policy" "aws_lambda_full_access" {
  name = "AWSLambda_FullAccess"
}

resource "aws_iam_user_policy" "ryanmissett_blog_github_deploy_policy_lambdas" {
  name = "ryanmissett_blog_github_deploy_policy_lambdas"
  user = aws_iam_user.ryanmissett_blog_github_deploy.name
  policy = data.aws_iam_policy.aws_lambda_full_access.policy
}

# lambda execution role setup

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy" "aws_lambda_basic_execution_role" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "ryanmissett_blog_lambda_hello_world" {
  name = "ryanmissett_blog_lambda_hello_world"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json 
  managed_policy_arns = [data.aws_iam_policy.aws_lambda_basic_execution_role.arn]
}

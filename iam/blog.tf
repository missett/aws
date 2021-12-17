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
      "arn:aws:s3:::ryanmissett-terraform-backend/blog"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::ryanmissett-terraform-backend"
    ]
  }

  # blog resource management

  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::ryanmissett-blog-frontend",
      "arn:aws:s3:::ryanmissett-blog-frontend/*",
    ]
  }
}

resource "aws_iam_user_policy" "ryanmissett_blog_github_deploy_policy" {
  name = "ryanmissett_blog_github_deploy_policy"
  user = aws_iam_user.ryanmissett_blog_github_deploy.name
  policy = data.aws_iam_policy_document.ryanmissett_blog_github_deploy_policy.json
}


locals {
  region = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ryanmissett-terraform-backend"
    key    = "iam"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      managed-by = "ryanmissett-terraform"
    }
  }
}

resource "aws_s3_bucket" "terraform_backend" {
  bucket = "ryanmissett-terraform-backend"
  acl = "private"
  
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_iam_account_alias" "account_alias" {
  account_alias = "ryanmissett"
}

resource "aws_iam_user" "ryan_missett_read_only" {
  name = "ryan_missett_read_only"
}

resource "aws_iam_group" "read_only_user_group" {
  name = "ReadOnlyUsers"
}

resource "aws_iam_group_policy_attachment" "read_only_user_group_policy_attachment" {
  group = aws_iam_group.read_only_user_group.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_group_membership" "read_only_user_group_membership" {
  name = "read_only_user_group_membership"
  
  users = [
    aws_iam_user.ryan_missett_read_only.name,
  ]

  group = aws_iam_group.read_only_user_group.name
}



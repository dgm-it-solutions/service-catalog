locals {
  role_name  = "github-actions-${var.repository_name}"
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy_attachment" "this" {
  name       = "${local.role_name}-policy-attachment"
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "this" {
  name   = "${local.role_name}-managed-policy"
  path   = "/github-actions/"
  policy = data.aws_iam_policy_document.this.json

}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "apigateway"
    effect  = "Allow"
    actions = ["apigateway:*"]
    resources = [
      # apigateway IAM is a mess, this is the best we can do for least privilege
      "arn:aws:apigateway:${local.aws_region}::/*",
      "arn:aws:apigateway:${local.aws_region}::/*/*",

    ]
  }


  statement {
    sid     = "lambda"
    effect  = "Allow"
    actions = ["lambda:*"]
    resources = [
      "arn:aws:lambda:${local.aws_region}:${local.account_id}:function:*",
      "arn:aws:lambda:${local.aws_region}:${local.account_id}:layer:*",
      "arn:aws:lambda:${local.aws_region}:${local.account_id}:event-source-mapping:*",
      "arn:aws:lambda:${local.aws_region}:${local.account_id}:code-signing-config:*",
    ]
  }

  statement {
    sid    = "cloudformationReadOnly"
    effect = "Allow"
    actions = [
      "cloudformation:Describe*",
      "cloudformation:List*",
      "cloudformation:Get*",
    ]
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "cloudformationWrite"
    effect = "Allow"
    actions = [
      "cloudformation:Create*",
      "cloudformation:Update*",
      "cloudformation:ExecuteChangeSet",
    ]
    resources = [
      "arn:aws:cloudformation:${local.aws_region}:${local.account_id}:changeSet/*/*",
      "arn:aws:cloudformation:${local.aws_region}:${local.account_id}:stack/${var.repository_name}*",
      "arn:aws:cloudformation:${local.aws_region}:aws:transform/Serverless-2016-10-31"
    ]
  }

  statement {
    sid    = "s3ReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListMultipartUploadParts"
    ]
    resources = [
      "arn:aws:s3:::aws-sam-cli-managed-default-samclisourcebucket-*/*",
      "arn:aws:s3:::aws-sam-cli-managed-default-samclisourcebucket-*",
    ]
  }

  statement {
    sid    = "s3Write"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]
    resources = [
      "arn:aws:s3:::aws-sam-cli-managed-default-samclisourcebucket-*/*",
    ]
  }

  statement {
    sid    = "iam"
    effect = "Allow"
    actions = [
      "iam:*",

    ]
    resources = [
      "arn:aws:iam::${local.account_id}:role/${var.repository_name}*",
    ]
  }

  statement {
    sid    = "iamPassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "lambda.amazonaws.com",
        "apigateway.amazonaws.com",
      ]
    }
  }

  statement {
    sid    = "dynamodb"
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      "arn:aws:dynamodb:${local.aws_region}:${local.account_id}:table/${var.repository_name}*",
      "arn:aws:dynamodb:${local.aws_region}:${local.account_id}:table/${var.repository_name}*/index/*",
      "arn:aws:dynamodb:${local.aws_region}:${local.account_id}:table/${var.repository_name}*/backup/*",
      "arn:aws:dynamodb:${local.aws_region}:${local.account_id}:table/${var.repository_name}*/stream/*",

    ]
  }


}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid    = "AllowGitHubActions"
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity",
    ]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${data.aws_iam_openid_connect_provider.github.url}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${data.aws_iam_openid_connect_provider.github.url}:sub"
      values = [
        "repo:ebanx/${var.repository_name}:ref:refs/heads/${var.default_branch_name}",
        "repo:ebanx/${var.repository_name}:pull_request",
        "repo:ebanx/${var.repository_name}:environment:*",
      ]
    }

  }

}


data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

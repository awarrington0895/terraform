terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
    tags = {
        all = ""
        project = "nx-playground"
    }
}

resource "aws_iam_user" "gitlab-nx-playground" {
    name = "gitlab-nx-playground"

    tags = local.tags

    policy = data.aws_iam_policy_document.gitlab-user-policy.json
}

data "aws_iam_policy_document" "gitlab-user-policy" {
    version = "2012-10-17"

    statement {
        sid = "VisualEditor0"
        effect = "Allow"

        actions = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
        ]

        resources = [
            "arn:aws:s3:::${module.hosting_bucket.name}/*"
        ]
    }

    statement {
        sid = "VisualEditor1"
        effect = "Allow"
        
        actions = [
            "s3:ListBucket"
        ]

        resources = [
            "*"
        ]
    }
}

module "hosting_bucket" {
    source = "../modules/aws-s3-static-website-bucket"

    bucket_name = "asw-react-test-app"

    tags = local.tags
}
locals {
    tags = {
      all = "",
      project = "elm-todo-app"
    }
}

resource "aws_iam_user" "github-actions-user" {
    name = "github-actions-user"

    tags = local.tags
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "upload-to-s3"
  user = aws_iam_user.github-actions-user.name

  policy = data.aws_iam_policy_document.github-user-policy.json
}

data "aws_iam_policy_document" "github-user-policy" {
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
    source = "../aws-s3-static-website-bucket"

    bucket_name = "asw-elm-todo-app"

    tags = local.tags
}
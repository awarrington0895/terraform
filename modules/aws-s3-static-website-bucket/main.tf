data "aws_iam_policy_document" "bucketPolicy" {
    version = "2012-10-17"

    statement {
        sid = "PublicReadGetObject"
        effect = "Allow"

        principals {
            type = "AWS"
            identifiers = [
                "*"
            ]
        }

        actions = [
            "s3:GetObject"
        ]

        resources = [
            "arn:aws:s3:::${var.bucket_name}/*"
        ]
    }
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = var.bucket_name

    force_destroy = true

    acl = "public-read"
    policy = data.aws_iam_policy_document.bucketPolicy.json

    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    tags = var.tags
}
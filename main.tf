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

resource "aws_resourcegroups_group" "allResources" {
  name = "all-resources"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "all"
    }
  ]
}
JSON
  }
}

module "hosting_bucket" {
    source = "./modules/aws-s3-static-website-bucket"

    bucket_name = "asw-elm-todo-app"

    tags = local.tags
}
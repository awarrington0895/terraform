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
    "*"
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
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

module "elm_app" {
  source = "./modules/elm-todo-app"
}
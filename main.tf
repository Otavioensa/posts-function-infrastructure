provider "aws" {
  profile = "credentials"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "posts-versions"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-1"
    profile = "credentials"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

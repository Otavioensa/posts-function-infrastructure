provider "aws" {
  profile = "standard-aws-credentials"
  region  = "us-east-1"
}

resource "aws_dynamodb_table" "application_table" {
  name           = "${var.tableName}-data"
  read_capacity  = 5
  write_capacity = 1

  hash_key = "day"

  attribute {
    name = "day"
    type = "S"
  }

  tags {
    Name    = "${var.tableName}"
    Project = "${var.project}"
    Env     = "staging"
  }
}

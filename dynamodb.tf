resource "aws_dynamodb_table" "application_table" {
  name           = "${var.tableName}"
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

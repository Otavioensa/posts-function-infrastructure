variable "tableName" {
  type    = "string"
  default = "posts"
}

variable "project" {
  type    = "string"
  default = "aws-lambda-function"
}

variable "bucketName" {
  type    = "string"
  default = "posts-versions"
}

variable "region" {
  type    = "string"
  default = "us-east-1"
}

resource "aws_s3_bucket" "application_repository" {
  bucket = "${var.bucketName}"
}

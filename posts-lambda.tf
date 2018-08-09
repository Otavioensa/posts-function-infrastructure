resource "aws_lambda_function" "posts_job" {
  function_name = "posts_job"
  s3_bucket     = "${aws_s3_bucket.application_repository.id}"
  s3_key        = "build.zip"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "src/syncPosts/index.syncPosts"
  runtime       = "nodejs8.10"
  timeout       = 10
}

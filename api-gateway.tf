resource "aws_api_gateway_rest_api" "posts_api" {
  name        = "${var.project}"
  description = "Posts API Gateway"
}

resource "aws_api_gateway_resource" "posts_api" {
  rest_api_id = "${aws_api_gateway_rest_api.posts_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.posts_api.root_resource_id}"
  path_part   = "savePosts"
}

resource "aws_api_gateway_method" "posts_run_job_method" {
  rest_api_id      = "${aws_api_gateway_rest_api.posts_api.id}"
  resource_id      = "${aws_api_gateway_resource.posts_api.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "posts_run_job_api_lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.posts_api.id}"
  resource_id = "${aws_api_gateway_method.posts_run_job_method.resource_id}"
  http_method = "${aws_api_gateway_method.posts_run_job_method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.posts_job.invoke_arn}"

  depends_on = [
    "aws_api_gateway_method.posts_run_job_method",
  ]
}

resource "aws_api_gateway_deployment" "posts_api" {
  depends_on = [
    "aws_api_gateway_integration.posts_run_job_api_lambda",
  ]

  variables {
    // Needs to be incremented when:
    // - Created new endpoint
    // - Updated enpoint (both path and http verb)
    version = "1"
  }

  rest_api_id = "${aws_api_gateway_rest_api.posts_api.id}"
  stage_name  = "${terraform.env}"
}

resource "aws_api_gateway_api_key" "posts_api_key" {
  name = "posts-api-key"

  stage_key {
    rest_api_id = "${aws_api_gateway_rest_api.posts_api.id}"
    stage_name  = "${aws_api_gateway_deployment.posts_api.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan" "posts" {
  name        = "posts-usage-plan"
  description = "Api Gateway Usage Plan"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.posts_api.id}"
    stage  = "${aws_api_gateway_deployment.posts_api.stage_name}"
  }

  depends_on = [
    "aws_api_gateway_deployment.posts_api",
  ]
}

resource "aws_api_gateway_usage_plan_key" "posts" {
  key_id        = "${aws_api_gateway_api_key.posts_api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.posts.id}"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "api_save_posts" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.posts_job.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.posts_api.id}/*/*/*"
}

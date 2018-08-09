resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "dynamo_policy" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PutItem",
    ]

    effect = "Allow"

    resources = [
      "${aws_dynamodb_table.application_table.arn}",
    ]
  }
}

resource "aws_iam_policy" "iam_policy_dynamo" {
  name        = "${var.project}"
  description = "App Policy ${var.project}"
  policy      = "${data.aws_iam_policy_document.dynamo_policy.json}"

  depends_on = [
    "data.aws_iam_policy_document.dynamo_policy",
  ]
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attach_dynamo" {
  role       = "${aws_iam_role.iam_for_lambda.name}"
  policy_arn = "${aws_iam_policy.iam_policy_dynamo.arn}"

  depends_on = [
    "aws_iam_role.iam_for_lambda",
    "aws_iam_policy.iam_policy_dynamo",
  ]
}

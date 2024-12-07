resource "aws_iam_user" "s3_user" {
  name          = "s3_user"
  path          = "/system/"
  force_destroy = true

  tags = var.default_tags
}

resource "aws_iam_access_key" "s3_user" {
  user = aws_iam_user.s3_user.name
}

data "aws_iam_policy_document" "s3_ro" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "s3_ro" {
  name   = "allow-access-to-s3-for-s3_user"
  user   = aws_iam_user.s3_user.name
  policy = data.aws_iam_policy_document.s3_ro.json
}

resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

output "s3_access_key" {
  value = aws_iam_access_key.s3_user_key.id
}

output "s3_secret_key" {
  value = nonsensitive(aws_iam_access_key.s3_user_key.secret)
}

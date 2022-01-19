
resource "aws_iam_user" "employee6174" {
  name = "employee_6174"
}

resource "aws_iam_policy" "employee_policy" {
  name = "a_employee_policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.employee6174.name
  policy_arn = aws_iam_policy.employee_policy.arn
}

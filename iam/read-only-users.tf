resource "aws_iam_user" "ryanmissett_read_only" {
  name = "ryanmissett_read_only"
}

resource "aws_iam_group" "read_only_user_group" {
  name = "ReadOnlyUsers"
}

resource "aws_iam_group_policy_attachment" "read_only_user_group_policy_attachment" {
  group = aws_iam_group.read_only_user_group.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_group_membership" "read_only_user_group_membership" {
  name = "read_only_user_group_membership"
  
  users = [
    aws_iam_user.ryanmissett_read_only.name,
  ]

  group = aws_iam_group.read_only_user_group.name
}


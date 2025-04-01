# Build our Assume Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Build our Custom Role
resource "aws_iam_role" "windows_patching" {
  name               = "windows-patching-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Attach our first Managed Policy to our Role
resource "aws_iam_role_policy_attachment" "ssm_managed_core" {
  role       = aws_iam_role.windows_patching.name
  policy_arn = data.aws_iam_policy.ssm_managed_core.arn
}

# Attach our second Managed Policy to our Role
resource "aws_iam_role_policy_attachment" "ssm_managed_window_role" {
  role       = aws_iam_role.windows_patching.name
  policy_arn = data.aws_iam_policy.ssm_managed_window_role.arn
}

# Build our Instance Profile and attach it to our Role
resource "aws_iam_instance_profile" "windows_patching" {
  name = "windows-patching-instance-profile"
  role = aws_iam_role.windows_patching.name
}
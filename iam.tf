# Define the IAM policy document that allows S3 access
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    # Replace with your actual bucket ARN pattern
    resources = [
      aws_s3_bucket.backup_bucket.arn,
      "${aws_s3_bucket.backup_bucket.arn}/*"
    ]
  }
}

# Create the IAM policy with the above permissions
resource "aws_iam_policy" "s3_access" {
  name   = "EC2S3BackupPolicy"
  policy = data.aws_iam_policy_document.s3_access_policy.json
}

# Create the IAM role trusted by EC2
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_s3_backup_role" {
  name               = "ec2-s3-backup-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Attach the S3 access policy to the role
resource "aws_iam_role_policy_attachment" "attach_s3_access" {
  role       = aws_iam_role.ec2_s3_backup_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# Create an instance profile to attach the role to EC2 instances
resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.ec2_s3_backup_role.name
}

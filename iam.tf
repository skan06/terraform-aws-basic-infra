###########################################
# IAM Policy for S3 Access (Backup)
###########################################
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    # Give access to the bucket and all its objects
    resources = [
      aws_s3_bucket.backup_bucket.arn,
      "${aws_s3_bucket.backup_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name   = "EC2S3BackupPolicy"
  policy = data.aws_iam_policy_document.s3_access_policy.json
}

###########################################
# IAM Policy for CloudWatch Logs
###########################################
data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"] # Or restrict to specific log group if known
  }
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name   = "EC2CloudWatchLogsPolicy"
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

###########################################
# IAM Role for EC2
###########################################
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

###########################################
# Attach Policies to EC2 Role
###########################################
resource "aws_iam_role_policy_attachment" "attach_s3_access" {
  role       = aws_iam_role.ec2_s3_backup_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs" {
  role       = aws_iam_role.ec2_s3_backup_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}

###########################################
# Instance Profile for EC2
###########################################
resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "ec2-s3-instance-profile"
  role = aws_iam_role.ec2_s3_backup_role.name
}

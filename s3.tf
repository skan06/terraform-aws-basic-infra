resource "aws_s3_bucket" "backup_bucket" {
  bucket = "skander-ec2-backup-${random_id.suffix.hex}"

  tags = {
    Name        = "EC2 Backup Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "backup_versioning" {
  bucket = aws_s3_bucket.backup_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "backup_bucket_block" {
  bucket = aws_s3_bucket.backup_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

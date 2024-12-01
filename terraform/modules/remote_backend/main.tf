resource "aws_iam_user" "terraform_user" {
  name = var.user_name
}

resource "aws_iam_policy_attachment" "terraform_policy" {
  name       = "terraform_policy_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  users      = [aws_iam_user.terraform_user.id]

}

resource "aws_s3_bucket" "terraform_state_bucket" {

  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    name = var.bucket_name
  }

}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "terraform_state_bucket_policy" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.terraform_state_bucket.arn,
          "${aws_s3_bucket.terraform_state_bucket.arn}/*"
        ],
        Principal = {
          AWS = aws_iam_user.terraform_user.arn
        }
      }
    ]
  })

}
resource "aws_dynamodb_table" "state_lock_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    name = var.table_name
  }
}
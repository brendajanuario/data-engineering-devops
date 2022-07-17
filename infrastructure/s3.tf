resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  acl    = "log-delivery-write"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "cognitivo-lake" {
  bucket = "${var.bucket_name}-${var.environment}"
  acl    = "private"
  force_destroy = true

  lifecycle {
    create_before_destroy = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}


resource "aws_kms_key" "cognitivo-datalake_kms" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.cognitivo-lake.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cognitivo-datalake_kms.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


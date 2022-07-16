resource "aws_s3_bucket_object" "spark-job" {
  bucket = aws_s3_bucket.cognitivo-lake.id
  key    = "python/glue-job/users/spark-job.py"
  acl    = "private"
  source = "../spark_job.py"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../spark_job.py")
}

resource "aws_s3_bucket_object" "users-schema" {
  bucket = aws_s3_bucket.cognitivo-lake.id
  key    = "raw/users/schema/types_mapping.json"
  acl    = "private"
  source = "../cognitivo-test-content/config/types_mapping.json"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../cognitivo-test-content/config/types_mapping.json")
}

resource "aws_s3_bucket_object" "users-data" {
  bucket = aws_s3_bucket.cognitivo-lake.id
  key    = "raw/users/load.csv"
  acl    = "private"
  source = "../cognitivo-test-content/data/input/users/load.csv"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../cognitivo-test-content/data/input/users/load.csv")
}
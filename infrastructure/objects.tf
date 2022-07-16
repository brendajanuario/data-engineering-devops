

resource "aws_s3_bucket_object" "spark-job" {
  bucket = aws_s3_bucket.cognitivo-lake.id
  key    = "glue-code/pyspark-job/cognitivo-etl.py"
  acl    = "private"
  source = "../spark_job.py"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../spark_job.py")
}
resource "aws_cloudwatch_log_group" "glue-cognitivo-users" {
  name              = "example"
  retention_in_days = 3
}

resource "aws_glue_job" "cognitivo-users-etl" {
  name     = "cognitivo-users-ETL"
  role_arn = aws_iam_role.glue-iam-role.arn

  command {
    script_location = "s3://${aws_s3_bucket.cognitivo-lake.bucket}/${aws_s3_bucket_object.spark-job.key}"
  }
  # ... other configuration ...

  default_arguments = {
    # ... potentially other arguments ...
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue-cognitivo-users.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
  }

}

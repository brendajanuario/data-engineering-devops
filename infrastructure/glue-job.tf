resource "aws_cloudwatch_log_group" "glue-cognitivo-users" {
  name              = "glue-cognitivo-users-log"
  retention_in_days = 3
}

resource "aws_glue_job" "cognitivo-users-etl" {
  name     = "cognitivo-users-ETL"
  role_arn = aws_iam_role.glue.arn

  command {
    script_location = "s3://${aws_s3_bucket.cognitivo-lake.bucket}/${aws_s3_bucket_object.spark-job.key}"
  }
  # ... other configuration ...

  default_arguments = {
    "--job-language" = "python"
    "--continuous-log-logGroup"          = aws_cloudwatch_log_group.glue-cognitivo-users.name
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
  }
  glue_version = "3.0"
  worker_type = "G.2X"
  number_of_workers = 2
  timeout = 4

}

resource "aws_glue_trigger" "glue_trigger" {
  name = "glue-cognitivo-users-trigger"
  type = "ON_DEMAND"
  actions {
    job_name = aws_glue_job.cognitivo-users-etl.name
  }

}
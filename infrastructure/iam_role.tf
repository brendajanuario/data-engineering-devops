resource "aws_iam_role" "glue" {
  name = "AWSGlueServiceRoleDefault"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "glue_service" {
    role = "${aws_iam_role.glue.id}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}


resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = "${aws_iam_role.glue.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.cognitivo-lake.arn}",
        "${aws_s3_bucket.cognitivo-lake.arn}/*"
      ]
    },
    {
      "Action": [
          "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::*:role/AWSGlueServiceRole*",
      "Condition": {
          "StringLike": {
              "iam:PassedToService": [
                  "glue.amazonaws.com"
              ]
          }
    }
  }

  ]
}
EOF
}

resource "aws_iam_role_policy" "kms_policy" {
  name = "kms_policy"
  role = "${aws_iam_role.glue.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": [
            "kms:Decrypt",
            "kms:Encrypt",
            "kms:GenerateDataKey"
        ],
        "Resource": [
          "${aws_kms_key.cognitivo-datalake_kms.arn}",
          "${aws_s3_bucket.cognitivo-lake.arn}/*"
      ]
    }
}
EOF
}
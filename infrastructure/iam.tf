resource "aws_iam_role" "lambda" {
  name = "igti-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name        = "igti-aws-lambda-basic-execution-role-policy"
  path        = "/"
  description = "Provides write permissions to CloudWatch Logs, S3 buckets and EMR Steps"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticmapreduce:*"
            ],
            "Resource": "*"
        },
        {
          "Action": "iam:PassRole",
          "Resource": ["arn:aws:iam::${var.conta_aws}:role/igti-emr-role",
                       "arn:aws:iam::${var.conta_aws}:role/igti-emr-ec2-role"],
          "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}



### GLUE ###
resource "aws_iam_role" "glue_role" {
  name = "igti-glue-crawler-role"

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

  tags = {
    IES   = "IGTI",
    CURSO = "EDC"
  }

}


resource "aws_iam_role_policy_attachment" "glue_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}


### EMR  ###

resource "aws_iam_role" "emr-role" {
  name = "igti-emr-role"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "elasticmapreduce.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = {
    IES   = "IGTI",
    CURSO = "EDC"
  }

}

resource "aws_iam_role_policy_attachment" "emr_attach" {
  role       = aws_iam_role.emr-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2"
}


resource "aws_iam_role" "emr-ec2-role" {
  name = "igti-emr-ec2-role"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = {
    IES   = "IGTI",
    CURSO = "EDC"
  }
  
}

resource "aws_iam_role_policy_attachment" "emr_ec2_attach" {
  role       = aws_iam_role.emr-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}
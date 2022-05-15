resource "aws_s3_bucket_object" "job_tratamento" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr-code/pyspark/job_tratamento.py"
  acl    = "private"
  source = "../etl/job_tratamento.py"
  etag   = filemd5("../etl/job_tratamento.py")
}

resource "aws_glue_catalog_database" "db" {
  name = "rais"
}

resource "aws_glue_crawler" "RAIS" {
  database_name = aws_glue_catalog_database.db.name
  name          = "s3_crawler_rais"
  role          = aws_iam_role.glue_service_role.arn

  s3_target {
    path = "s3://${var.nome_bucket}/staging/rais/"
  }

  configuration = <<EOF
    {
      "Version": 1.0,
      "Grouping": {
        "TableGroupingPolicy": "CombineCompatibleSchemas" 
      }
    }
  EOF

  tags = {
    IES   = "IGTI"
    CURSO = "EDC"
  }

}
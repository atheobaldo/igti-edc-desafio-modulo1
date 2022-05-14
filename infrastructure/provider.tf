provider "aws" {
  region = "sa-east-1"
}

# Centralizar o arquivo de controle de estado do terraform
# Criar bucket manualmente na AWS
terraform {
  backend "s3" {
    bucket = var.nome_bucket
    key    = "terraform/state/terraform.tfstate"
    region = var.aws_region
  }
}
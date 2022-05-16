provider "aws" {
  region = "us-east-2"
}

# Centralizar o arquivo de controle de estado do terraform
# Criar bucket manualmente na AWS
terraform {
  backend "s3" {
    bucket = "igti-terraform-atheobaldo"
    key    = "terraform/state/terraform.tfstate"
    region = "us-east-2"
  }
}
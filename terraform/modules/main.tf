
terraform {
  required_providers {
    aws={
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region
}

module "backend" {
  source = "./terraform/modules/remote_backend"
  user_name = var.user_name
  bucket_name = var.bucket_name
  table_name = var.table_name
}

output "terraform_user" {
  value = module.backend.user_name
}

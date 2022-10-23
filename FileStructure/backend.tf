terraform {
  backend "s3" {
    bucket         = "aws-session-may2022-remote-backend-hik"
    key            = "multi-vpc-task/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-may2022-state-lock-table"
  }
}
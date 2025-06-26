terraform {
  backend "s3" {
    bucket = "tf-state-shres8-101"
    key = "backend/project.tfstate"
    region = "us-east-1"
    dynamodb_table = "remote-backend"
  }
}

terraform {
  backend "s3" {
    bucket         = "your-bucket-name"
    key            = "terraform.tfstate"
    region         = "your-region"  # e.g., us-east-1
    dynamodb_table = "terraform-state-lock"
  }
}

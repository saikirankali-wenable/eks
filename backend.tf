terraform {
  backend "s3" {
    bucket = "terraform_bucket_tfsstate"
    key = "terraform/eks/terraform.tfstate"
    dynamodb_table = "locking_statefile"
    
  }
}
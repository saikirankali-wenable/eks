terraform {
  backend "s3" {
    bucket = "terraform_bucket_tfsstate"
    key = "terraform/eks/eks.tfstate"
    
  }
}
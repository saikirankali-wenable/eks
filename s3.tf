resource "aws_s3_bucket" "mybucket" {
    bucket = "terraform_bucket_tfsstate"
    acl = "private"
    versioning {
      enabled = true
    }
  
}
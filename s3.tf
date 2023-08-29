resource "aws_s3_bucket" "mybucket" {
    bucket = "terraform_bucket_tfsstate"
    acl = "private"
    versioning {
      enabled = true
    }
  
}

resource "aws_dynamodb_table" "dynamodb" {
  name             = "locking_statefile"
  hash_key         = "LOCKID"
  billing_mode     = "PROVISIONED"
  read_capacity    = 2
  write_capacity   = 2

  attribute {
    name = "LOCKID"
    type = "String"
  }
}
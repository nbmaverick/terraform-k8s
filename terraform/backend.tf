# backend setup block
terraform {
  backend "s3" {
    bucket = "bucket-for-s3backendmaverick" # create s3 in aws
    #dynamodb_table = "state-lock"                            # create dynamo table in aws
    key     = "global/mystatefile/vpc"
    region  = "eu-west-1"
    encrypt = true
  }
} 
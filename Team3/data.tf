data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket             = "bucket-for-s3backendmaverick"     # create s3 in aws
    #dynamodb_table = "state-lock"                            # create dynamo table in aws
    key                = "global/mystatefile/vpc"
    region             = "eu-west-1"
    encrypt            = true
  }
}

data "terraform_remote_state" "asg" {
  backend = "s3"
  config = {
    bucket             = "bucket-for-s3backendmaverick"     # create s3 in aws
    #dynamodb_table = "state-lock"                            # create dynamo table in aws
    key                = "global/mystatefile/asg"
    region             = "eu-west-1"
    encrypt            = true
  }
}
output "full_list" {
  value = data.terraform_remote_state.main.outputs.*
}
